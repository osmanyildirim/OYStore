Pod::Spec.new do |s|
  s.name                      = "OYStore"
  s.version                   = "1.0.2"
  s.summary                   = "Save persistent data or file in UserDefaults, Keychain, File System, Memory Cache, URLCache."

  s.homepage                  = "https://github.com/osmanyildirim/OYStore.git"
  s.license                   = { :type => "MIT", :file => "LICENSE" }
  s.author                    = { "osmanyildirim" => "github.com/osmanyildirim" }

  s.ios.deployment_target     = "11.0"
  s.swift_version             = "5.7"
  s.requires_arc              = true

  s.source                    = { git: "https://github.com/osmanyildirim/OYStore.git", :tag => s.version }
  s.source_files              = "Sources/**/*.*"
end