
export CI_OPT_ORIGIN_REPO_SLUG="${CI_OPT_ORIGIN_REPO_SLUG:-ci-and-cd/maven-build}";

export CI_OPT_OSSRH_SONAR_ORGANIZATION="${CI_OPT_OSSRH_SONAR_ORGANIZATION:-home1-oss-github}";

export CI_OPT_INFRASTRUCTURE="${CI_OPT_INFRASTRUCTURE:-ossrh}";
export GIT_HOST="${GIT_HOST:-github.com}";
if [[ -z "${GIT_PREFIX}" ]]; then export GIT_PREFIX="https://${GIT_HOST}"; fi;
export CI_OPT_GPG_KEYNAME="${CI_OPT_GPG_KEYNAME:-59DBF10E}";
export CI_OPT_MVN_MULTI_STAGE_BUILD="${CI_OPT_MVN_MULTI_STAGE_BUILD:-false}";
export CI_OPT_NEXUS2_STAGING="${CI_OPT_NEXUS2_STAGING:-true}";

if [[ -n "${APPVEYOR_REPO_BRANCH}" ]]; then export APPVEYOR_ENABLED="${APPVEYOR_ENABLED:-true}"; fi;
if [[ -n "${CI_COMMIT_REF_NAME}" ]]; then export GITLAB_CI="${GITLAB_CI:-true}"; fi;
if [[ -n "${TRAVIS_BRANCH}" ]]; then export TRAVIS_ENABLED="${TRAVIS_ENABLED:-true}"; fi;
if [[ "${CI_OPT_FAST}" != "true" ]]; then export CI_OPT_MAVEN_EFFECTIVE_POM="${CI_OPT_MAVEN_EFFECTIVE_POM:-false}"; fi;

if [[ -z ${CI_OPT_GITHUB_SITE_PUBLISH} ]]; then
  if [[ "${APPVEYOR_ENABLED}" == "true" ]]; then if [[ "${APPVEYOR_REPO_BRANCH}" =~ ^release/.+ ]] || [[ "${APPVEYOR_REPO_BRANCH}" =~ ^support/.+ ]]; then export CI_OPT_GITHUB_SITE_PUBLISH="true"; else export CI_OPT_GITHUB_SITE_PUBLISH="false"; fi; fi;
  if [[ "${GITLAB_CI}" == "true" ]]; then if [[ "${CI_COMMIT_REF_NAME}" =~ ^release/.+ ]] || [[ "${CI_COMMIT_REF_NAME}" =~ ^support/.+ ]]; then export CI_OPT_GITHUB_SITE_PUBLISH="true"; else export CI_OPT_GITHUB_SITE_PUBLISH="false"; fi; fi;
  if [[ "${TRAVIS_ENABLED}" == "true" ]]; then if [[ "${TRAVIS_BRANCH}" =~ ^release/.+ ]] || [[ "${TRAVIS_BRANCH}" =~ ^support/.+ ]]; then export CI_OPT_GITHUB_SITE_PUBLISH="true"; else export CI_OPT_GITHUB_SITE_PUBLISH="false"; fi; fi;
fi;
if [[ "${CI_OPT_GITHUB_SITE_PUBLISH}" == "true" ]]; then
  if [[ "${APPVEYOR_ENABLED}" == "true" ]]; then export CI_OPT_GITHUB_GLOBAL_REPOSITORYOWNER="$(echo ${APPVEYOR_REPO_NAME} | awk -F'/' '{print $1}')"; fi;
  if [[ "${GITLAB_CI}" == "true" ]]; then export CI_OPT_GITHUB_GLOBAL_REPOSITORYOWNER="$(echo ${CI_PROJECT_PATH} | awk -F'/' '{print $1}')"; fi;
  if [[ "${TRAVIS_ENABLED}" == "true" ]]; then export CI_OPT_GITHUB_GLOBAL_REPOSITORYOWNER="$(echo ${TRAVIS_REPO_SLUG} | awk -F'/' '{print $1}')"; fi;
  export CI_OPT_GITHUB_GLOBAL_REPOSITORYNAME="${CI_OPT_GITHUB_GLOBAL_REPOSITORYOWNER}";
else
  if [[ -z ${PUBLISH_CHANNEL} ]]; then
    if [[ -n "${APPVEYOR_REPO_BRANCH}" ]]; then REF_NAME="${APPVEYOR_REPO_BRANCH}"; elif [[ -n "${CI_COMMIT_REF_NAME}" ]]; then REF_NAME="${CI_COMMIT_REF_NAME}"; elif [[ -n "${TRAVIS_BRANCH}" ]]; then REF_NAME="${TRAVIS_BRANCH}"; fi;
    if [[ "${REF_NAME}" =~ ^release/.+ ]] || [[ "${REF_NAME}" =~ ^support/.+ ]] || [[ "${REF_NAME}" =~ ^hotfix/.+ ]]; then
      export PUBLISH_CHANNEL="release";
    elif [[ "${REF_NAME}" =~ ^feature/.+ ]] || [[ "${REF_NAME}" == "develop" ]]; then
      export PUBLISH_CHANNEL="snapshot";
    fi;
  fi;
  if [[ -n "${PUBLISH_CHANNEL}" ]]; then SITE_PATH_PREFIX="${PUBLISH_CHANNEL}/"; fi;
  if [[ "${APPVEYOR_ENABLED}" == "true" ]]; then export CI_OPT_SITE_PATH="${SITE_PATH_PREFIX}${APPVEYOR_REPO_NAME}"; fi;
  if [[ "${GITLAB_CI}" == "true" ]]; then export CI_OPT_SITE_PATH="${SITE_PATH_PREFIX}${CI_PROJECT_PATH}"; fi;
  if [[ "${TRAVIS_ENABLED}" == "true" ]]; then export CI_OPT_SITE_PATH="${SITE_PATH_PREFIX}${TRAVIS_REPO_SLUG}"; fi;
fi;

if [[ -z "${CI_OPT_MAVEN_BUILD_OPTS_REPO}" ]]; then export CI_OPT_MAVEN_BUILD_OPTS_REPO="${GIT_PREFIX}/ci-and-cd/maven-build-opts-${CI_OPT_INFRASTRUCTURE:-ossrh}"; fi;
if [[ -z "${CI_OPT_MAVEN_BUILD_OPTS_REPO_REF}" ]]; then
  if [[ "${APPVEYOR_ENABLED}" == "true" ]]; then export CI_OPT_MAVEN_BUILD_OPTS_REPO_REF="${APPVEYOR_REPO_BRANCH:-develop}"; fi;
  if [[ "${GITLAB_CI}" == "true" ]]; then export CI_OPT_MAVEN_BUILD_OPTS_REPO_REF="${CI_COMMIT_REF_NAME:-develop}"; fi;
  if [[ "${TRAVIS_ENABLED}" == "true" ]]; then export CI_OPT_MAVEN_BUILD_OPTS_REPO_REF="${TRAVIS_BRANCH:-develop}"; fi;
fi;
#if [[ "${APPVEYOR_ENABLED}" == "true" ]]; then export SETTINGS_GLOBAL_XML="${SETTINGS_GLOBAL_XML:-/home/appveyor/.m2/wrapper/dists/topinfra-maven-dist-1.1.1/44uavdht26vl6k299u2ig39i9e/apache-maven-3.6.1/conf/settings.xml}"; fi;
##if [[ "${GITLAB_CI}" == "true" ]]; then export SETTINGS_GLOBAL_XML="${SETTINGS_GLOBAL_XML:-/var/lib/gitlab-runner/.m2/wrapper/dists/topinfra-maven-dist-1.1.1/44uavdht26vl6k299u2ig39i9e/apache-maven-3.6.1/conf/settings.xml}"; fi;
#if [[ "${GITLAB_CI}" == "true" ]]; then export SETTINGS_GLOBAL_XML="${SETTINGS_GLOBAL_XML:-/tmp/settings-global-${CI_COMMIT_SHA}.xml}"; fi;
#if [[ "${TRAVIS_ENABLED}" == "true" ]]; then export SETTINGS_GLOBAL_XML="${SETTINGS_GLOBAL_XML:-/home/travis/.m2/wrapper/dists/topinfra-maven-dist-1.1.1/44uavdht26vl6k299u2ig39i9e/apache-maven-3.6.1/conf/settings.xml}"; fi;
#export SETTINGS_GLOBAL_XML_URL="${CI_OPT_MAVEN_BUILD_OPTS_REPO}/raw/${CI_OPT_MAVEN_BUILD_OPTS_REPO_REF}/src/main/maven/settings-global.xml";
