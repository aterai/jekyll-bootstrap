---
layout: post
title: JFrameのサイズを固定
category: swing
folder: FixedSizeFrame
tags: [JFrame, JDialog]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2004-05-17

## JFrameのサイズを固定
`JFrame`や`JDialog`のサイズを固定し、変更不可にします。


{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTM4ZlDyXI/AAAAAAAAAZ4/xXHwfOJP7p0/s800/FixedSizeFrame.png %}

### サンプルコード
<pre class="prettyprint"><code>frame.setResizable(false);
</code></pre>

### 解説
`JFrame#setResizable`メソッドで、フレームのサイズを変更不可にしています。タイトルバーの最大化ボタンなども選択できなくなります。

リサイズの可不可を切り替えると、`LookAndFeel`によっては装飾が変化して`JFrame`自体のサイズが変化する場合があります。

### コメント
- アイコン化ボタンを無効化する方法はないようですね。`JInternalFrame`ならクローズも最大化もアイコン化も全部いじれるのに。 -- [さく](http://terai.xrea.jp/さく.html) 2004-08-12 (木) 15:17:30
- なんだかなさそうですね。`JDialog`を使うか、以下みたいにして誤魔化すか…、`LookAndFeel`を自作すれば何とかなるのかな？ -- [aterai](http://terai.xrea.jp/aterai.html) 2004-08-12 (木) 17:01:45

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>//XPだと「画面のプロパティ」「デザイン」「次のアニメーション効果を…」
//を無効にしないと、ちょっとかっこ悪い。
frame.addWindowListener(new WindowAdapter() {
  @Override public void windowIconified(WindowEvent e) {
    frame.setState(frame.NORMAL);
  }
});
</code></pre>

- ~~[Go state-of-the-art with IFrame](http://www.ibm.com/developerworks/library/j-iframe/) も面白そうです。IBMだから`SWT`使ってるのかなと思ったら`JFrame`を継承して作られています。~~ -- [aterai](http://terai.xrea.jp/aterai.html) 2004-08-12 (木) 18:31:16
- レイアウト変更したときに`setAlwaysOnTop`が紛れ込んで、`Java Web Start`でサンプルが起動できなくなっていた不具合を修正。 -- [aterai](http://terai.xrea.jp/aterai.html) 2009-03-14 (土) 17:44:18

<!-- dummy comment line for breaking list -->

