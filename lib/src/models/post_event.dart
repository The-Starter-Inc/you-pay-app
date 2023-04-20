import 'package:event/event.dart';
import 'package:p2p_pay/src/models/post.dart';

class PostEvent extends EventArgs {
  late Post post;
  PostEvent(this.post);
}
