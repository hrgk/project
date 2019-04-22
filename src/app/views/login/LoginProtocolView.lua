local BaseLayer = import("..base.BaseLayer")
local LoginProtocolView = class("LoginProtocolView", BaseLayer)
local TYPES = gailun.TYPES
local nodes = {
    type = TYPES.ROOT, children = {
        {type = TYPES.SPRITE, filename = "res/images/box/view_bg.png", var = "rootLayer_", scale9 = true, size = {display.width* 0.73 * WIDTH_SCALE, display.height* 0.95 * HEIGHT_SCALE}, x = display.cx, y = display.cy, capInsets = cc.rect(340, 150, 1, 1),
                children = {
                    {type = TYPES.LABEL, var = "labelTitleName_", options = {text = "游戏用户协议", size = 35, color = cc.c4b(255, 255, 0, 255), font = DEFAULT_FONT}, ppx = 0.5, ppy = 0.97 ,ap = {0.5,0.5}},
                    {type = TYPES.BUTTON, var = "buttonClosed_", autoScale = 0.9, normal = "res/images/box/x.png", 
                        options = {}, ppx = 0.98, ppy = 0.92 },
                    {type = TYPES.SCROLL_VIEW, var = "rankListView", options = {viewRect = cc.rect(35, 45, display.width * 0.685, display.height * 0.75), direction = 1},
                },
            }
        }
    }
}

local protocolText = {[[
    长沙神游网络科技有限公司（以下又称“神游”或“神游网络”，在《文化部网络游戏服务格式化协议必备条款》当中又被称为“甲方”）在此特别提醒用户（在《文化部网络游戏服务格式化协议必备条款》当中又被称为“乙方”）仔细阅读本《〈朋来棋牌〉网络游戏用户协议》（下称“本《用户协议》”）中的各个条款，包括但不限于免除或者限制神游责任的条款、对用户权利进行限制的条款以及约定争议解决方式、司法管辖的条款。
    请您仔细阅读本《用户协议》（未成年人应当在其法定监护人陪同下阅读），并选择接受或者不接受本《用户协议》。除非您同意并接受本《用户协议》中的所有条款，否则您无权接收、下载、安装、启动、升级、登录、显示、运行、截屏《朋来棋牌》网络游戏，亦无权使用该游戏软件的某项功能或某一部分或者以其他的方式使用该游戏软件。您接收、下载、安装、启动、升级、登录、显示、运行、截屏《朋来棋牌》网络游戏，或者使用该游戏软件的某项功能、某一部分，或者以其他的方式使用该游戏软件的行为，即视为您同意并接受本《用户协议》，愿意接受本《用户协议》所有条款的约束。
    您若与神游因本《用户协议》或其补充协议所涉及的有关事宜发生争议或者纠纷，双方可以友好协商解决；协商不成的，您完全同意双方当中的任何一方均可以将其提交神游所在地广东省长沙有管辖权的人民法院诉讼解决。
    本《用户协议》分为两大部分，第一部分是文化部根据《网络游戏管理暂行规定》（文化部令第49号）制定的《网络游戏服务格式化协议必备条款》，第二部分是神游根据《中华人民共和国著作权法》、《中华人民共和国合同法》、《著作权行政处罚实施办法》、《网络游戏管理暂行规定》等国家法律法规拟定的《朋来棋牌》网络游戏《用户协议》条款。内容如下：
      
      第一部分 文化部网络游戏服务格式化协议必备条款

    根据《网络游戏管理暂行规定》（文化部令第49号），文化部制定《网络游戏服务格式化协议必备条款》。甲方为网络游戏运营企业，乙方为网络游戏用户。
    1.账号注册
    1.1 乙方承诺以其真实身份注册成为甲方的用户，并保证所提供的个人身份资料信息真实、完整、有效，依据法律规定和必备条款约定对所提供的信息承担相应的法律责任。
    1.2 乙方以其真实身份注册成为甲方用户后，需要修改所提供的个人身份资料信息的，甲方应当及时、有效地为其提供该项服务。
    2.用户账号使用与保管
    2.1 根据必备条款的约定，甲方有权审查乙方注册所提供的身份信息是否真实、有效，并应积极地采取技术与管理等合理措施保障用户账号的安全、有效；乙方有义务妥善保管其账号及密码，并正确、安全地使用其账号及密码。任何一方未尽上述义务导致账号密码遗失、账号被盗等情形而给乙方和他人的民事权利造成损害的，应当承担由此产生的法律责任。
    2.2 乙方对登录后所持账号产生的行为依法享有权利和承担责任。
    2.3 乙方发现其账号或密码被他人非法使用或有使用异常的情况的，应及时根据甲方公布的处理方式通知甲方，并有权通知甲方采取措施暂停该账号的登录和使用。
    2.4 甲方根据乙方的通知采取措施暂停乙方账号的登录和使用的，甲方应当要求乙方提供并核实与其注册身份信息相一致的个人有效身份信息。
    2.4.1 甲方核实乙方所提供的个人有效身份信息与所注册的身份信息相一致的，应当及时采取措施暂停乙方账号的登录和使用。
    2.4.2 甲方违反2.4.1款项的约定，未及时采取措施暂停乙方账号的登录和使用，因此而给乙方造成损失的，应当承担其相应的法律责任。
    2.4.3 乙方没有提供其个人有效身份证件或者乙方提供的个人有效身份证件与所注册的身份信息不一致的，甲方有权拒绝乙方上述请求。
    2.5 乙方为了维护其合法权益，向甲方提供与所注册的身份信息相一致的个人有效身份信息时，甲方应当为乙方提供账号注册人证明、原始注册信息等必要的协助和支持，并根据需要向有关行政机关和司法机关提供相关证据信息资料。
    3.服务的中止与终止
    3.1 乙方有发布违法信息、严重违背社会公德、以及其他违反法律禁止性规定的行为，甲方应当立即终止对乙方提供服务。
    3.2 乙方在接受甲方服务时实施不正当行为的，甲方有权终止对乙方提供服务。该不正当行为的具体情形应当在本协议中有明确约定或属于甲方事先明确告知的应被终止服务的禁止性行为，否则，甲方不得终止对乙方提供服务。
    3.3 乙方提供虚假注册身份信息，或实施违反本协议的行为，甲方有权中止对乙方提供全部或部分服务；甲方采取中止措施应当通知乙方并告知中止期间，中止期间应该是合理的，中止期间届满甲方应当及时恢复对乙方的服务。
    3.4 甲方根据本条约定中止或终止对乙方提供部分或全部服务的，甲方应负举证责任。
    4.用户信息保护
    4.1 甲方要求乙方提供与其个人身份有关的信息资料时，应当事先以明确而易见的方式向乙方公开其隐私权保护政策和个人信息利用政策，并采取必要措施保护乙方的个人信息资料的安全。
    4.2 未经乙方许可甲方不得向任何第三方提供、公开或共享乙方注册资料中的姓名、个人有效身份证件号码、联系方式、家庭住址等个人身份信息，但下列情况除外：
    4.2.1 乙方或乙方监护人授权甲方披露的；
    4.2.2 有关法律要求甲方披露的；
    4.2.3 司法机关或行政机关基于法定程序要求甲方提供的；
    4.2.4 甲方为了维护自己合法权益而向乙方提起诉讼或者仲裁时；
    4.2.5 应乙方监护人的合法要求而提供乙方个人身份信息时。

      第二部分 深圳神游网络服务有限公司用户服务条款

    一、总则
    1.1 本《协议》为您（即用户）与深圳神游网络务有限公司（以下简称神游网络）就神游网络所提供的服务达成的协议。神游网络在此特别提醒您认真阅读、充分理解本《用户服务协议》（下称《协议》）--- 用户应认真阅读、充分理解本《协议》中各条款，特别涉及免除或者限制神游网络责任的免责条款，对用户的权利限制的条款，法律适用、争议解决方式的条款。
    1.2 请您审慎阅读并选择同意或不同意本《协议》，除非您接受本《协议》所有条款，否则您无权下载、安装、升级、登录、显示、运行、截屏等方式使用本软件及其相关服务。您的下载、安装、显示、帐号获取和登录、截屏等行为表明您自愿接受本协议的全部内容并受其约束，不得以任何理由包括但不限于未能认真阅读本协议等作为纠纷抗辩理由。
    1.3 本《协议》可由神游网络随时更新，更新后的协议条款一旦公布即代替原来的协议条款，不再另行个别通知。您可重新下载安装本软件或网站查阅最新版协议条款。在神游网络修改《协议》条款后，如果您不接受修改后的条款，请立即停止使用神游网络提供的软件和服务，您继续使用神游网络提供的软件和服务将被视为已接受了修改后的协议。
    1.4 本《协议》内容包括但不限于本协议以下内容，针对某些具体服务所约定的管理办法、公告、重要提示、指引、说明等均为本协议的补充内容，为本协议不可分割之组成部分，具有本协议同等法律效力，接受本协议即视为您自愿接受以上管理办法、公告、重要提示、指引、说明等并受其约束；否则请您立即停止使用神游网络提供的软件和服务。
    二、特殊规定
    2.1 未满十八周岁的未成年人应经其监护人陪同阅读本服务条款并表示同意，方可接受本服务条款。监护人应加强对未成年人的监督和保护，因其未谨慎履行监护责任而损害未成年人利益或者影响神游网络利益的，应由监护人承担责任。
    2.2 青少年用户应遵守全国青少年网络文明公约：要善于网上学习，不浏览不良信息；要诚实友好交流，不侮辱欺诈他人；要增强自护意识，不随意约会网友；要维护网络安全，不破坏网络秩序；要有益身心健康，不沉溺虚拟时空。
    三、权利声明
    3.1 神游网络拥有向最终用户提供内容服务的、网址中包含www.renren6.com的互联网网站、以及《朋来棋牌》网络游戏平台（以下简称《朋来棋牌》）及其服务器端、最终客户端程序、文档的（包括上述内容的升级、改进版本）的所有权和一切知识产权，包括但不限于：
    3.1.1 《朋来棋牌》软件及其他物品的著作权、版权、名称权、商标权以及由其派生的各项权利；
    3.1.2 《朋来棋牌》中的电子文档、文字、数据库、图片、图标、图示、照片、程序、音乐、色彩、版面设计、界面设计等可从作品中单独使用的作品元素的著作权、版权、名称权、商标权以及由其派生的各项权利；
    3.1.3 神游网络向用户提供服务过程中所产生并存储于神游网络系统中的任何数据（包括但不限于账号、元宝、经验值、级别等游戏数据）的所有权。
    3.1.4 用户在使用《朋来棋牌》游戏过程中产生的电子文档、文字、图片、照片、色彩、游戏界面等可以单独使用的游戏元素，以及由其形成的截屏、录像、录音等衍生品的各项权利。
    3.2 上述权利神游网络书面授权用户以非商业、不损害神游网络利益的目的临时的、有限的、不可转让的使用权。用户不得为商业运营目的安装、使用、运行“朋来棋牌”，不可以对该软件或者该软件运行过程中释放到任何计算机终端内存中的数据及该软件运行过程中客户端与服务器端的交互数据进行复制、更改、修改、挂接运行或创作任何衍生作品，形式包括但不限于使用截屏、插件、外挂或非经授权的第三方工具/服务接入本“软件”和相关系统。
    3.3 未经神游网络书面同意，用户以任何营利性、非营利性或损害神游网络利益的目的实施以下几种行为的，神游网络保留追究上述未经许可行为一切法律责任的权利，给神游网络造成经济或名誉上损失的，神游网络有权根据相关法律法规另行要求赔偿，情节严重涉嫌犯罪的，神游网络将提交司法机关追究刑事责任：
    3.3.1 进行编译、反编译等方式破解该软件作品的行为；
    3.3.2 利用技术手段破坏软件系统或者服务器的行为；
    3.3.3 利用游戏外挂、作弊软件、系统漏洞侵犯神游网络利益的行为；
    3.3.4 对游戏进行截屏、录像或利用游戏中数据、图片、截屏进行发表的行为；
    3.3.5 制作游戏线下衍生品的行为；
    3.3.6 其他严重侵犯神游网络知识产权的行为。
    四、用户基本权利和责任
    4.1 用户享有由神游网络根据实际情况提供的各种服务，包括但不限于线上游戏、网上论坛、举办活动等。在某些情况下，神游网络许可用户以其JJ账号登录或使用神游网络合作方运营的产品或服务。
    4.2 用户可以通过元宝兑换等方式获得神游网络的服务。用户充值元宝至固定账号后，未经神游网络书面同意不得将元宝再转至其他账号。
    4.3 用户认为自己在游戏中的权益受到侵害，有权根据神游网络相关规定进行投诉申诉。
    4.4 用户有权对神游网络的管理和服务提出批评、意见、建议，有权就客户服务相关工作向客服提出咨询。
    4.5 用户在《朋来棋牌》的游戏活动应遵守中华人民共和国法律、法规，遵守神游网络的相关管理规定（包括但不限于管理办法、禁止性和限制性行为等），并自行承担因游戏活动直接或间接引起的一切法律责任。
    4.6 用户有权自主选择依照游戏设定的方式和规则进行竞赛或游戏，对其游戏活动承担相应责任和由此产生的损失，包括经济损失和精神损害。神游网络就用户的游戏的行为、活动、交易或利用《朋来棋牌》进行的非法活动不承担任何责任。
    4.7 用户需遵守网络道德，注意网络礼仪，做到文明上网。
    4.8 神游网络仅提供相关的网络服务，除此之外与相关网络服务有关的上网设备(如电脑、调制解调器及其他互联网接入装置)及所需的费用（如为接入互联网而支付的电话费、上网费）均应由用户自行负担。
    五、用户账号
    5.1 账号注册
    5.1.1 在神游网络根据国家法律法规要求需要您以真实身份注册成为神游网络游戏的用户时，您应提供真实身份信息进行注册并保证所提供的个人身份资料信息真实、完整、有效，并依据法律规定和本条款约定对所提供的信息承担相应的法律责任。
    5.1.2 账号和昵称注册应符合法律法规和社会公德的要求，不得以党和国家领导人或其他名人的真实姓名、字号、艺名、笔名和不文明、不健康用语注册。
    5.1.3 您以真实身份注册成为神游网络用户后，需要修改所提供的个人身份资料信息的，神游网络将及时、有效地为您提供该项服务。
    5.1.4 账户所有权归属于神游网络，用户享有该账户在游戏运营期间的使用权。
    5.2 用户账号使用与保管
    5.2.1 神游网络有权审查用户注册所提供的身份信息是否真实、有效，并应积极地采取技术与管理等合理措施保障用户账号的安全、有效；用户有义务妥善保管其账号及密码，并根据神游网络的要求正确、安全地使用其账号及密码。因黑客行为或用户保管疏忽等非神游网络过错导致帐号、密码遭他人非法使用，神游网络不承担任何责任。
    5.2.2 用户对登录后所持账号产生的行为依法享有权利和承担责任。
    5.2.3 用户发现其账号或密码被他人非法使用或有使用异常的情况的，应及时根据神游网络公布的账号申述规则通知神游网络，并有权通知神游网络采取措施暂停该账号的登录和使用。
    5.2.4 神游网络根据用户的通知采取措施暂停用户账号的登录和使用的，神游网络有权要求用户提供并核实与其注册身份信息相一致的个人有效身份信息。用户没有提供其个人有效身份证件或者用户提供的个人有效身份证件与所注册的身份信息不一致的，神游网络有权拒绝用户上述请求。
    六、用户信息保护
    6.1 神游网络将保护用户提供的有效个人信息数据的安全。不对外向任何第三方提供、公开或共享用户注册资料中的姓名、个人有效身份证件号码、联系方式、家庭住址等个人身份信息，但下列情况除外：
    6.1.1 用户或用户监护人授权披露的；
    6.1.2 有关法律要求披露的；
    6.1.3 司法机关或行政机关基于法定程序要求提供的；
    6.1.4 神游网络为了维护自己合法权益而披露；
    6.1.5 应用户监护人的合法要求而提供用户个人身份信息时。
    6.2 神游网络要求用户提供与其个人身份有关的信息资料时，已事先以明确而易见的方式向用户公开其隐私保护政策和个人信息利用政策，并采取必要措施保护用户的个人信息资料的安全。
    七、服务的中止与终止
    7.1 用户实施或有重大可能实施以下行为的，神游网络有权中止对其部分或全部服务，中止提供服务的方式包括但不限于暂停对该账号的登录和使用、暂时禁止使用充值服务、暂时禁止兑换相应奖品、降低或者清除账号中的积分、游戏道具等、暂时禁止使用论坛服务：
    7.1.1 私下进行买卖游戏道具的行为；
    7.1.2 提供虚假注册身份信息的行为；
    7.1.3 游戏中合伙作弊，尚未对其他用户利益造成严重影响的行为；
    7.1.4 发布不道德信息、广告、言论、辱骂骚扰他人，扰乱正常的网络秩序和游戏秩序的行为；
    7.1.5 实施违反本协议和相关规定、管理办法、公告、重要提示，对神游网络和其他用户利益造成损害的其他行为。
    7.2 用户实施或有重大可能实施以下不正当行为的，神游网络有权终止对用户提供服务，终止提供服务的方式包括但不限于永久性的删除该账号、发表的帖子、留言、将非法所得的积分和荣誉道具清零：
    7.2.1 发布违法信息、严重违背社会公德、以及其他违反法律禁止性规定的行为；
    7.2.2 利用《朋来棋牌》进行赌博活动的行为；
    7.2.3 涉嫌买卖偷盗的虚拟财产、游戏道具的行为；
    7.2.4 游戏中合伙作弊对其他用户利益造成严重影响的行为；
    7.2.5 用非法手段盗取其他用户账号和虚拟财产、游戏道具的行为；
    7.2.6 论坛、游戏中传播非法讯息、木马病毒、外挂软件等的行为；
    7.2.7 利用游戏作弊工具或者外挂、游戏bug获取非法利益，严重侵犯神游网络利益的行为；
    7.2.8 发布不道德信息、广告、言论、辱骂骚扰他人，严重扰乱正常的网络秩序和游戏秩序的行为；
    7.2.9 实施违反本协议和相关规定、管理办法、公告、重要提示，对神游网络和其他用户利益造成严重损害的其他行为。
    7.3 本协议中未涉及到的禁止或限制性行为及处罚规则，由神游网络针对具体服务制定相关规定、管理办法、公告、重要提示、指引、说明等，视为本协议之补充协议，为本协议不可分割之组成部分，具有本协议同等法律效力，接受本协议即视为您自愿接受相关规定、管理办法、公告、重要提示、指引、说明等并受其约束。
    八、免责条款
    8.1 用户之间因线上游戏行为所发生或可能发生的任何心理、生理上的伤害和经济上的损失，神游网络不承担任何责任。
    8.2 用户因其个人原因造成账号资料保管不妥而导致个人信息数据被他人泄露或账号中虚拟财产、游戏道具被盗或损失的，神游网络不承担任何责任。
    8.3 用户因除了按游戏规则进行游戏的行为外的其他行为触犯了中华人民共和国法律法规的，责任自负，朋来棋牌不承担任何责任。
    8.4 用户账号长期不使用的，神游网络有权进行回收，因此带来的用户个人信息数据丢失、账户内虚拟财产和游戏道具清零等一切损失由用户个人承担，神游网络不承担任何责任。
    8.5 用户因违反本协议7.1、7.2条款而被神游网络采取处罚措施所产生的一切损失包括但不限于虚拟货币、积分、荣誉被清零、道具失效或其他损失，均由用户个人承担，神游网络不承担任何责任。
    8.6 基于网络环境的复杂性，神游网络不担保服务一定能满足用户的要求，也不保证各项服务不会中断，对服务的及时性、安全性也不作担保。因网络安全、网络故障问题和其他用户的非法行为给用户造成的损失，朋来棋牌不承担任何责任。
    8.7 基于网络环境的特殊性，神游网络不担保对用户限制性行为和禁止性行为的判断的准确性，用户因此产生的任何损失神游网络不承担任何责任，用户可按神游网络相关规定进行申诉解决。
    8.8 神游网络不保证您从第三方获得的神游网络虚拟货币、游戏道具（金币、门票）等游戏物品能正常使用，也不保证该等物品不被索回，因私下购买虚拟货币、游戏道具（金币、门票）等游戏物品所产生的一切损失均由用户承担，神游网络不承担任何责任。
    九、法律适用和争议解决
    本协议的订立、效力、解释、履行和争议的解决均适用中华人民共和国法律。因本协议所产生的以及因履行本协议而产生的任何争议，双方均应本着友好协商的原则加以解决。
    十、其他
    10.1 不弃权原则。除非得到双方签字盖章的书面形式证明，否则，不得对本协议任何条款进行修改、修订或放弃。任何一方未能按照本协议规定行使权力或进行补救或延误进行，不得视为该方放弃行使该种权力，除非本协议另有明文规定。
]]}


function LoginProtocolView:ctor()
    LoginProtocolView.super.ctor(self)
    gailun.uihelper.render(self, nodes)

    self:initLabel_()
    self.buttonClosed_:onButtonClicked(handler(self, self.onButtonBackClicked_))
end

function LoginProtocolView:initLabel_()
    local node = self.rankListView:getScrollNode()
    if node then
        node:removeFromParent()
    end
    local params = {type = TYPES.LABEL, x = 35 , y = display.height * 0.75 + 45, ap = {0, 1}, 
        options = {text = protocolText[1], 
                size = 24, color = cc.c3b(255, 255, 255), font = DEFAULT_FONT, dimensions = cc.size(display.width * 0.685, display.height * 11), align = cc.TEXT_ALIGNMENT_LEFT,},}
    local node  = display.newNode()
    local newNode = gailun.uihelper.createObject(params)
    -- newNode:setLineHeight(40)
    -- newNode:setAdditionalKerning(2)
    -- newNode:setMaxLineWidth(display.width * 0.2)
    -- newNode:setLineBreakWithoutSpace(true)
    node:addChild(newNode)
    node:setContentSize(cc.size(0, 0))
    self.rankListView:addScrollNode(node)
end

function LoginProtocolView:onButtonBackClicked_(event)
    self:dispatchEvent({name = "CHECK_BOX_PROTOCOL", event = true})
    self:removeFromParent(true)
end

return LoginProtocolView
