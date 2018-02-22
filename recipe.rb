class Apr < FPM::Cookery::Recipe
  $tomcat_major_version = '7'                           #Tomcat major version.
  $tomcat_version       = "#$tomcat_major_version.0.50" #Tomcat version, it should be start with major version.
  $jdk_version          = '1.8.0_121'                   #Latest Turn-jdk version.
  $native_source_loc    = '/jni/native'                 #Native source location to compile

  description   'apr'
  name          'apr'
  version       '1.1.29'
  revision      0
  homepage      'http://tomcat.apache.org/'
  source        "http://archive.apache.org/dist/tomcat/tomcat-#$tomcat_major_version/v#$tomcat_version/bin/apache-tomcat-#$tomcat_version.tar.gz"
  md5           '2d2278cf1126bc7443ba0d80324ba574'
  arch          'x86_64'
  build_depends 'libapr1-dev', "openjdk-8-jdk", 'openssl'

  def extract
    cmd = "tar -xzf ./bin/tomcat-native.tar.gz > /dev/null 2>&1"
    result, stdout, stderr = system cmd
  end

  def build
    extract
    Dir.chdir "./tomcat-native-#{version}-src/#$native_source_loc/"
    configure \
      '--prefix=/usr/local/apr',
      '--with-apr=/usr/bin',
      "--with-java-home=/usr/java/jdk#$jdk_version",
      "--with-ssl=yes"
    make
  end

  def install
    make :install, 'DESTDIR' => destdir, 'PREFIX' => prefix
  end
end