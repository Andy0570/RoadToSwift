屏幕的相对尺寸是以尺寸等级（size class）来定义的。一个尺寸等级代表了给定维度下屏幕空间的相对状态。每个维度（宽度和高度）都被归类为紧凑（compact）或常规（regular），因此有四种尺寸类别的组合：

| 尺寸等级                      | 描述                                                         |
| ----------------------------- | ------------------------------------------------------------ |
| Compact Width、Compact Height | iPhones with 4, 4.7, or 5.8-inch screens in landscape orientation |
| Compact Width、Regular Height | iPhones of all sizes in portrait orientation                 |
| Regular Width、Compact Height | iPhones with 5.5, 6.1, or 6.5-inch screens in landscape orientation |
| Regular Width、Regular Height | iPads of all sizes in all orientations                       |

现在，你应该可以理解 Interface Builder 底部视图的符号了。例如，视图为: iPhone11 Pro (wC hR) ，意味着选定的设备和方向被分类为紧凑宽度（wC）和常规高度（hR）。

请注意，在 iPad 上以 Split View 或滑屏方式运行的应用程序不会填满整个 iPad 屏幕，所以它们通常会有一个紧凑的宽度。

请注意，尺寸等级同时涵盖了屏幕尺寸和方向。与其从设备方向或硬件的角度来考虑 UI，不如从尺寸等级的角度来考虑。

