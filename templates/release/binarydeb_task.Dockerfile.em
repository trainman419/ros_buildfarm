# generated from @template_name

FROM @os_name:@os_code_name
MAINTAINER @maintainer_name @maintainer_email

VOLUME ["/var/cache/apt/archives"]

@[if arch == 'armhf']@
ADD qemu-arm-static /usr/bin/qemu-arm-static
@[end if]@

ENV DEBIAN_FRONTEND noninteractive
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

RUN useradd -u @uid -m buildfarm

RUN mkdir /tmp/keys
@[for i, key in enumerate(distribution_repository_keys)]@
RUN echo "@('\\n'.join(key.splitlines()))" > /tmp/keys/@(i).key
RUN apt-key add /tmp/keys/@(i).key
@[end for]@
@[for url in distribution_repository_urls]@
RUN echo deb @url @os_code_name main | tee -a /etc/apt/sources.list.d/buildfarm.list
@[end for]@

RUN mkdir /tmp/wrapper_scripts
@[for filename, content in wrapper_scripts.items()]@
RUN echo "@('\\n'.join(content.replace('"', '\\"').splitlines()))" > /tmp/wrapper_scripts/@(filename)
@[end for]@

# optionally manual cache invalidation for core dependencies
RUN echo "2014-11-20"

@# Ubuntu before Trusty explicitly needs python3
@[if os_name == 'ubuntu' and os_code_name[0] < 't']@
RUN apt-get update && apt-get install -q -y python3
@[end if]@

# automatic invalidation once every day
@{
import datetime
today_isoformat = datetime.date.today().isoformat()
}@
RUN echo "@today_isoformat"

# for each dependency: echo version, apt-get update, apt-get install
@[for d in dependencies]@
RUN echo "@d: @dependency_versions[d]" && python3 -u /tmp/wrapper_scripts/apt-get.py update && python3 -u /tmp/wrapper_scripts/apt-get.py install -q -y @d
@[end for]@

USER buildfarm
ENTRYPOINT ["sh", "-c"]
@{
cmd = \
    'PYTHONPATH=/tmp/ros_buildfarm:$PYTHONPATH python3 -u' + \
    ' /tmp/ros_buildfarm/scripts/release/build_binarydeb.py' + \
    ' ' + rosdistro_name + \
    ' ' + package_name + \
    ' --sourcedeb-dir ' + binarydeb_dir
}@
CMD ["@cmd"]
