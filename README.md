# Swift-JsonAnalytical
使用Swift解析Json

使用方法：

  !!!注意Int、Float、Double等一些NSNumber类型的数据必须先赋值，否则会报错

>  // 要解析的类
> <code>class Persion: NSObject {
>    var name: String!`
>    var age: Int = 0
>    var childs: [Child]!
>  }
  
  class Child: NSObject {
    var name: String!
    var age: Int!
  }
  
  let json: AnyObject = [
            "name": "LiSi",
            "age": 29,
            "childs":
            [
                ["name": "LiZhi", "age": 1],
                ["name": "LiZhiYi", "age": 2],
                ["name": "LiZhiEr", "age": 3]
            ]
        ]
        
  let persion: AnyObject! = Json.jsonToModel(json, className: "Persion")</code>
  
  解析完成
