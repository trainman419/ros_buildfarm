  <scm class="hudson.plugins.git.GitSCM" plugin="git@@2.3">
    <configVersion>2</configVersion>
    <userRemoteConfigs>
      <hudson.plugins.git.UserRemoteConfig>
        <url>@ESCAPE(url)</url>
      </hudson.plugins.git.UserRemoteConfig>
    </userRemoteConfigs>
    <branches>
      <hudson.plugins.git.BranchSpec>
        <name>@ESCAPE(refspec)</name>
      </hudson.plugins.git.BranchSpec>
    </branches>
    <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
    <submoduleCfg class="list"/>
    <extensions>
@[if relative_target_dir]@
      <hudson.plugins.git.extensions.impl.RelativeTargetDirectory>
        <relativeTargetDir>@ESCAPE(relative_target_dir)</relativeTargetDir>
      </hudson.plugins.git.extensions.impl.RelativeTargetDirectory>
@[end if]@
    </extensions>
  </scm>
