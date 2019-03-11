# SmashTag

#### 引入并使用其他framework框架
1. 新建workspace用来作为project的容器，把SmashTag.xcodeproj和Twitter.xcodeproj文件拖入workspace
2. target切换到twitter，设备切换为generic iOS device，编译生成需要的framework文件
3. target切换到SmashTag，点击SmashTag,把刚才生成的framework拖拽到`Embeded Binaries`
4.在使用的文件中 使用 import 导入

#### 使用UITableview展示数据
表格视图分为动态表格和静态表格，静态表格的cell直接在storyboard中配置即可，不需要通过代码提供datasource以及实现datasource协议。静态cell的控件可以直接连在UITableViewController中。
动态cell的数据源需要通过代码配置，tableView的数据模型一旦发生变更，就需要立刻告诉tableView去刷新数据。
刷新数据有两种方法：
- reloadData():这个方法比较重，会刷新整个表格
- reloadRows(at indexPaths:[indexPath],with animation:UItableViewRowAnimation):轻量级的刷新，只更新指定变更的部分。

#### 使用自定义Cell
1. cell类型选择Custom，设置identifier
2. 使用autoLayout进行布局
3. 创建UItableViewCell的子类，与cell相关联
4. 创建cell的API用来更新cell
5. 在tableView返回cell的方法中，获取cell并转换为自定义cell


#### 支持动态行高
1. 提供行高默认值
2. 使用自动计算行高
```swift
tableView.estimatedRowHeight = tableView.rowHeight// 预估行高和storyborad中设置一致
tableView.rowHeight = UITableView.automaticDimension//自动计算行高
```
