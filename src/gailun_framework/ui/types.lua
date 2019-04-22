-- 说明
-- 名词解释
-- textures: 所需用到的纹理，类型为{纹理1, 纹理2, ... } 每一个都是一个table
-- var: 所生成对象在其root中的变量名
-- parentVar: 所生成对象在其parent中的变量名
-- type: 对象类型, 见下面的对象类型表
-- filename: 对象所调用的资源图片名称
-- children: 对象的子对象列表, 注意children要用数组形式来保持元素之间的顺序，从而保证渲染层级关系
-- x,y: 对象的X、Y坐标
-- size: table 对象的宽、高, 如{200, 100}
-- px, py: 百分比坐标, 用0～1来表达百分比，这个是全局坐标
-- ppx, ppy: 相对父对象的原点的百分比坐标，比值是父对象的宽高, 用0～1来表达百分比，这个坐标是与父对象相关的，不是全局坐标
-- offset: 偏移量，目前是button的label用到此属性
-- scale: 对象缩放量，等比缩放
-- scalex: 对象X方向缩放
-- scaley: 对象Y方向缩放
-- flipX: bool 是否水平翻转
-- flipY: bool 是否垂直翻转
-- rotate: 对象的旋转
-- align: 参数类型为table，参见display.align的数据类型来设定
-- options: 对象选项，一般情况下用于UILabel, UIButton等系统控件的构造选项
-- class: 用于表示自定义组件的路径及类名，格式为 "path.directory.ClassName", 必须用require可直接require到。
-- ap: Anchor Point, table, 两项，用于构造cc.p(unpack(XX))，请参考其它文档查看AnchorPoint
-- classParams: 自定义class的构造参数，可使用数字索引的table来传递多个参数
-- labels: 按钮和Checkbox的组件的属性，按钮有normal\pressed\disabled等状态，checkbox有on.off等状态, 可用来标示label在不同的按钮状态的文字属性
-- visible: 对象可见性，默认为true，要隐藏则设为false
-- opacity: 对象透明度
-- touchEnabled: boolean 关闭或者打开对象的触摸响应
-- isGray: boolean 是否变灰, 默认为false
-- direction: display.BOTTOM_TO_TOP... 目前专指slider的方向，可参考 display 的方向常量
-- images: 图片列表，目前指button、slider、checkbox所用到的一系列的图片，可参考它们的构造函数参数说明

local TYPES = {
    ROOT = 0,  -- 根对象，不会真正创建出来，但会加载它的textures，并创建它的children
    LAYER = 1,
    NODE = 2,
    SPRITE = 3,
    BUTTON = 4,
    LOADING_BAR = 5,
    SLIDER = 6,
    CHECK_BOX = 7,
    BM_FONT_LABEL = 8,
    LABEL = 9,
    LABEL_ATLAS = 10,
    EDIT_BOX = 11,
    SCROLL_VIEW = 12,
    LIST_VIEW = 13,
    PAGE_VIEW = 14,  -- 本类及以上都代表UI库里的相关的组件，可一一对应，它们的options选项也可以找到对应项
    CHECK_BOX_GROUP = 15,  -- checkbox 组
    CUSTOM = 16,  -- 这个是自定义类型，自定义类型需要再指定class属性才可以正常创建
    PROGRESS_TIMER = 17,  -- 对应cc.ProgressTimer
    JW_SLIDER = 18, -- 对应 gailun.JWSlider, 与Slider的区别是对bar的处理，这里会裁剪，而slider里面不会
    LAYER_COLOR = 19 , -- 带颜色的层
    CLIPPING_NODE = 20, -- 裁切的节点
}

return TYPES
