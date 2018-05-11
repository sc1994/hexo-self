### 安装
- [在Ubuntu上安装](https://www.microsoft.com/net/download/linux-package-manager/ubuntu16-04/sdk-current)
- 其他 (todo)
---
### Build
- 编译当前目录下的代码
```
dotnet build 
```
- 以生产环境编译当前目录下的代码，且指定输出（相对）路径
```
dotnet publish -c Release -o bin/Release/PublishOutput
```
---
### Config
- 使用ConfigurationBuilder来注入生成配置文件
```C#
public static T GetConfigJson<T>(string key, string fileName = "appsettings.json") where T : class, new()
{
    var builder = new ConfigurationBuilder()
   .SetBasePath(Directory.GetCurrentDirectory())
   .AddJsonFile(fileName);
    var config = builder.Build();

    var entity = new T();
    config.GetSection(key).Bind(entity);
    return entity;
}

public static string GetAppSetting(string key, string fileName= "appsettings.json")
{
    var builder = new ConfigurationBuilder()
   .SetBasePath(Directory.GetCurrentDirectory())
   .AddJsonFile(fileName);
    var config = builder.Build();

    return config.GetSection(key).Value;
}
```
- 有些时候我们需要自定义配置文件，那么我们需要将配置文件也编译到对应的目录
```xml
  <ItemGroup>
    <None Update="Config\appsettings.json">
      <CopyToOutputDirectory>PreserveNewest</CopyToOutputDirectory>
    </None>
  </ItemGroup>
```
