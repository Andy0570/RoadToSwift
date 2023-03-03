import Foundation

// Scene：指的是一个由视图控制器管理的视图。它可以是一个普通的视图，也可以是一个弹出对话框。它包括一个视图控制器和一个视图模型。

// Scene 是由视图控制器管理的视图和视图模型组成的一个逻辑演示单元。Scene 的三个规则：
// 1.视图模型处理业务逻辑。这可以延伸到启动场景之间的过渡。
// 2.视图模型对用于表示 Scene 的实际视图控制器和视图一无所知。
// 3.视图控制器不应该启动场景之间的过渡；这是视图模型中的业务逻辑。

enum Scene {
    case tasks(TasksViewModel)
    case editTask(EditTaskViewModel)
}
