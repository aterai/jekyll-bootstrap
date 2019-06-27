---
layout: post
category: swing
folder: FixedSizeFrame
title: JFrameのサイズを固定
tags: [JFrame, JDialog]
author: aterai
pubdate: 2004-05-17T02:42:23+09:00
description: JFrameやJDialogのサイズを固定し、変更不可にします。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTM4ZlDyXI/AAAAAAAAAZ4/xXHwfOJP7p0/s800/FixedSizeFrame.png
comments: true
---
## 概要
`JFrame`や`JDialog`のサイズを固定し、変更不可にします。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTM4ZlDyXI/AAAAAAAAAZ4/xXHwfOJP7p0/s800/FixedSizeFrame.png %}

## サンプルコード
<pre class="prettyprint"><code>frame.setResizable(false);
</code></pre>

## 解説
上記のサンプルでは、`JFrame#setResizable(...)`メソッドを使用して`JFrame`をマウスなどでリサイズ不可に設定しています。

- タイトルバーの最大化ボタンなども選択不可になる
- この設定を切り替えると、`LookAndFeel`依存のフレーム装飾が変化して`JFrame`自体のサイズも変化する場合がある

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Frame#setResizable(boolean) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/Frame.html#setResizable-boolean-)

<!-- dummy comment line for breaking list -->

## コメント
- アイコン化ボタンを無効化する方法はないようですね。`JInternalFrame`ならクローズも最大化もアイコン化も全部いじれるのに。 -- *さく* 2004-08-12 (木) 15:17:30
- なんだか無さそうですね。`JDialog`を使うか、以下のように誤魔化すか…、`LookAndFeel`を自作すれば何とかなるのかな？ -- *aterai* 2004-08-12 (木) 17:01:45
    
    <pre class="prettyprint"><code>frame.addWindowListener(new WindowAdapter() {
      @Override public void windowIconified(WindowEvent e) {
        frame.setExtendedState(Frame.NORMAL);
      }
    });
</code></pre>
- ~~[Go state-of-the-art with IFrame](https://www.ibm.com/developerworks/library/j-iframe/)~~(リンク切れ)も面白そうです。IBMだから`SWT`使ってるのかなと思ったら`JFrame`を継承して作られています。 -- *aterai* 2004-08-12 (木) 18:31:16
- レイアウト変更したときに`setAlwaysOnTop`が紛れ込んで、`Java Web Start`でサンプルが起動できなくなっていた不具合を修正。 -- *aterai* 2009-03-14 (土) 17:44:18

<!-- dummy comment line for breaking list -->
