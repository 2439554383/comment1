import 'package:comment1/page/person/personal_center/user_agreement/user_agreement_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UserAgreement extends StatelessWidget {
  const UserAgreement({super.key});

  @override
  build(BuildContext context) {
    return GetBuilder(
      init: UserAgreementCtrl(),
      builder: (UserAgreementCtrl ctrl) => Scaffold(
        appBar: AppBar(
          title: Text(
            "用户协议",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 0, bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15.h),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 0),
                    child: ListView(
                      children: [
                        Text(
                          "本应用非常重视用户权益保护并严格遵守相关的法律规定。请您仔细阅读《用户协议》后再继续使用。如果您继续使用我们的服务，表示您已经充分阅读和理解我们协议的全部内容。",
                          style: TextStyle(fontSize: 14.sp, height: 1.6),
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          "本app尊重并保护所有使用服务用户的合法权益。为了给您提供更准确、更优质的AI文本生成服务，本应用会按照本用户协议的规定提供服务。您在同意本应用服务使用协议之时，即视为您已经同意本用户协议全部内容。",
                          style: TextStyle(fontSize: 14, height: 1.6),
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          "1. 服务说明",
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.h),
                        Text("(a) 本应用是一款AI文本生成应用，为用户提供智能文本生成、评论生成、内容创作等服务；", style: TextStyle(fontSize: 14.sp, height: 1.6)),
                        Text("(b) 用户使用本应用生成的所有内容，其版权归属用户所有，但用户需对生成内容的合法性负责；", style: TextStyle(fontSize: 14, height: 1.6)),
                        Text("(c) 本应用提供的AI文本生成服务基于算法模型，生成内容仅供参考，用户应当自行判断内容的适用性和准确性；", style: TextStyle(fontSize: 14, height: 1.6)),
                        Text("(d) 本应用保留根据法律法规要求或业务需要修改、暂停或终止部分或全部服务的权利。", style: TextStyle(fontSize: 14, height: 1.6)),
                        SizedBox(height: 20.h),
                        Text(
                          "2. 算法使用说明与用户权益",
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.h),
                        Text("(a) 算法使用范围：本应用使用的AI算法主要用于文本生成、内容推荐、个性化服务等功能；", style: TextStyle(fontSize: 14, height: 1.6)),
                        Text("(b) 用户权利：用户有权了解算法推荐的基本原理、目的和主要运行机制；", style: TextStyle(fontSize: 14, height: 1.6)),
                        Text("(c) 用户有权自主选择是否接受算法推荐服务，可以通过设置关闭或限制算法推荐功能；", style: TextStyle(fontSize: 14, height: 1.6)),
                        Text("(d) 用户有权拒绝基于算法的个性化推荐，选择使用基础服务模式；", style: TextStyle(fontSize: 14, height: 1.6)),
                        Text("(e) 用户协议中已明确说明算法使用范围及用户权利，用户使用服务即表示已知晓并同意；", style: TextStyle(fontSize: 14, height: 1.6)),
                        Text("(f) 我们承诺不会利用算法进行价格歧视、大数据杀熟等损害用户权益的行为。", style: TextStyle(fontSize: 14, height: 1.6)),
                        SizedBox(height: 20.h),
                        Text(
                          "3. 用户权益保护措施",
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.h),
                        Text("(a) 用户协议明确说明：本协议已明确说明算法使用范围及用户权利，确保用户充分了解算法服务的边界；", style: TextStyle(fontSize: 14, height: 1.6)),
                        Text("(b) 提供算法关闭/拒绝使用选项：用户可以在应用设置中关闭算法推荐功能，选择使用基础服务模式；", style: TextStyle(fontSize: 14, height: 1.6)),
                        Text("(c) 建立用户投诉反馈渠道：我们建立了完善的用户投诉反馈机制，用户可通过应用内举报功能、客服邮箱、在线客服等多种方式反馈问题，我们将在收到反馈后及时处理并给予回复。", style: TextStyle(fontSize: 14, height: 1.6)),
                        SizedBox(height: 20.h),
                        Text(
                          "4. 内容审核与生态治理",
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.h),
                        Text("(a) 建立内容审核机制：我们建立了完善的内容审核机制，采用人工审核与AI智能审核相结合的方式，对用户生成的内容进行审核，确保内容符合法律法规和社区规范；", style: TextStyle(fontSize: 14, height: 1.6)),
                        Text("(b) 设置用户举报功能：用户可以对违法违规、不良信息等内容进行举报，我们将在收到举报后及时核实并处理；", style: TextStyle(fontSize: 14, height: 1.6)),
                        Text("(c) 定期进行算法安全评估：我们定期对使用的算法进行安全评估，确保算法的公平性、透明性和安全性，防范算法滥用风险；", style: TextStyle(fontSize: 14, height: 1.6)),
                        Text("(d) 严禁用户发布不良信息：如裸露、色情、暴力、诽谤、欺诈等内容，一经发现将禁用该用户的所有权限，予以封号处理。", style: TextStyle(fontSize: 14, height: 1.6)),
                        SizedBox(height: 20.h),
                        Text(
                          "5. 用户行为规范",
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.h),
                        Text("(a) 用户在使用本应用时，应当遵守国家法律法规，不得利用本应用从事违法违规活动；", style: TextStyle(fontSize: 14, height: 1.6)),
                        Text("(b) 用户不得利用本应用生成、发布、传播违法违规内容，包括但不限于：危害国家安全、破坏社会稳定、侵犯他人合法权益、传播虚假信息等；", style: TextStyle(fontSize: 14, height: 1.6)),
                        Text("(c) 用户不得恶意攻击、干扰本应用的正常运行，不得利用技术手段规避平台监管；", style: TextStyle(fontSize: 14, height: 1.6)),
                        Text("(d) 用户应当妥善保管账户信息，对账户下的所有行为负责。", style: TextStyle(fontSize: 14, height: 1.6)),
                        SizedBox(height: 20.h),
                        Text(
                          "6. 知识产权",
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.h),
                        Text("(a) 本应用的所有知识产权，包括但不限于商标、专利、著作权等，均归本应用所有；", style: TextStyle(fontSize: 14, height: 1.6)),
                        Text("(b) 用户通过本应用生成的内容，其知识产权归属用户，但用户授权本应用在提供服务过程中使用该内容；", style: TextStyle(fontSize: 14, height: 1.6)),
                        Text("(c) 未经本应用书面许可，用户不得以任何形式复制、传播、展示本应用的任何内容。", style: TextStyle(fontSize: 14, height: 1.6)),
                        SizedBox(height: 20.h),
                        Text(
                          "7. 隐私保护",
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.h),
                        Text("(a) 本应用严格保护用户隐私，具体隐私政策请参阅《隐私政策》；", style: TextStyle(fontSize: 14, height: 1.6)),
                        Text("(b) 我们不会向第三方提供、出售或出租用户的个人信息，除非法律法规要求或获得用户明确同意；", style: TextStyle(fontSize: 14, height: 1.6)),
                        Text("(c) 我们采用行业标准的安全技术措施保护用户数据安全。", style: TextStyle(fontSize: 14, height: 1.6)),
                        SizedBox(height: 20.h),
                        Text(
                          "8. 免责声明",
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.h),
                        Text("(a) 本应用提供的AI文本生成服务仅供参考，用户应当自行判断生成内容的适用性和准确性；", style: TextStyle(fontSize: 14, height: 1.6)),
                        Text("(b) 因用户使用本应用生成的内容导致的任何损失或纠纷，本应用不承担法律责任；", style: TextStyle(fontSize: 14, height: 1.6)),
                        Text("(c) 因不可抗力、系统故障等原因导致的服务中断或数据丢失，本应用不承担责任。", style: TextStyle(fontSize: 14, height: 1.6)),
                        SizedBox(height: 20.h),
                        Text(
                          "9. 协议变更",
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.h),
                        Text("(a) 本应用有权根据法律法规变化或业务需要修改本协议，修改后的协议将在应用内公布；", style: TextStyle(fontSize: 14, height: 1.6)),
                        Text("(b) 如对本协议作出重大更改，我们将通过应用内通知、短信等方式告知用户；", style: TextStyle(fontSize: 14, height: 1.6)),
                        Text("(c) 如用户不同意修改后的协议，可以停止使用本应用；继续使用则视为接受修改后的协议。", style: TextStyle(fontSize: 14, height: 1.6)),
                        SizedBox(height: 20.h),
                        Text(
                          "10. 联系方式",
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.h),
                        Text("本公司（上海一棵树网络科技有限公司成立于2018年12月26日，注册地位于上海市嘉定区华江路129弄7号JT7483室 电话：15618268878 邮箱地址：13356797958@163.com）保留随时修改本协议的权利，因此请经常查看。如对本协议作出重大更改，本公司会通过网站通知的形式告知。", style: TextStyle(fontSize: 14, height: 1.6)),
                        SizedBox(height: 20.h),
                        Text(
                          "感谢您花时间了解我们的用户协议！我们将尽全力保护您的合法权益，提供优质的AI文本生成服务，再次感谢您的信任！",
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        // GestureDetector(
                        //   onTap: ctrl.openAgreementUrl,
                        //   child: Text.rich(
                        //     TextSpan(
                        //       text: "用户协议网址：",
                        //       style: TextStyle(fontSize: 14, color: Colors.black),
                        //       children: [
                        //         TextSpan(
                        //           text: ctrl.agreementUrl,
                        //           style: TextStyle(
                        //             fontSize: 14,
                        //             color: Colors.blue,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget item1(BuildContext context, UserAgreementCtrl ctrl) {
    return Container();
  }
}

