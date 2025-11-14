# プロジェクト全体の最小対応 iOS バージョン
platform :ios, '16.0'

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
      end
    end
  end
end

target 'MinnanoTanjyoubi' do
  # ダイナミックフレームワーク (.framework) でビルド
  use_frameworks!

  # Pods for MinnanoTanjyoubi
  pod 'RealmSwift'
  pod 'SwiftFormat/CLI', :configurations => ['Debug']

  target 'MinnanoTanjyoubiTests' do 
    use_frameworks!

    pod 'RealmSwift'
  end

end


target 'BirthDayWidgetExtension' do
  use_frameworks!

  # Pods for WidgetTest
  pod 'RealmSwift'

end
