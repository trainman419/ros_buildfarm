from configparser import ConfigParser
import os


def get_credentials(jenkins_url=None):
    config = ConfigParser()
    config_file = get_credential_path()
    if not os.path.exists(config_file):
        return None, None

    config.read(config_file)
    section_name = None
    if jenkins_url is not None and jenkins_url in config:
        section_name = jenkins_url
    if section_name is None and 'DEFAULT' in config:
        section_name = 'DEFAULT'

    if section_name is None or 'username' not in config[section_name] or \
            'password' not in config[section_name]:
        return None, None
    return config[section_name]['username'], config[section_name]['password']


def get_credential_path():
    return os.path.join(
        os.path.expanduser('~'), get_relative_credential_path())


def get_relative_credential_path():
    return os.path.join('.buildfarm', 'jenkins.ini')
