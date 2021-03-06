---
layout: post
category: swing
folder: CloseOperation
title: JFrameの複数作成と終了
tags: [JFrame, WindowListener]
author: aterai
pubdate: 2005-06-27T01:43:23+09:00
description: JFrameを複数作成し、これらをすべて閉じた時にアプリケーションを終了します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTJey1HvEI/AAAAAAAAAUc/KdbEeHP-Ij0/s800/CloseOperation.png
comments: true
---
## 概要
`JFrame`を複数作成し、これらをすべて閉じた時にアプリケーションを終了します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTJey1HvEI/AAAAAAAAAUc/KdbEeHP-Ij0/s800/CloseOperation.png %}

## サンプルコード
<pre class="prettyprint"><code>private static int number = 0;
public static JFrame createFrame(String title) {
  JFrame frame = new JFrame((title == null) ? "Frame #" + number : title);
  frame.setDefaultCloseOperation(WindowConstants.DISPOSE_ON_CLOSE);
  number++;
  // frame.addWindowListener(new WindowAdapter() {
  //   @Override public void windowClosing(WindowEvent e) {
  //   number--;
  //     if (number == 0) {
  //       JFrame f = (JFrame) e.getSource();
  //       f.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
  //     }
  //   }
  // });
  return frame;
}
</code></pre>

## 解説
上記のサンプルでは、すべての`JFrame`に`setDefaultCloseOperation(WindowConstants.DISPOSE_ON_CLOSE)`を設定しているため、`Java VM`内で最後の表示可能な`Window`が破棄されると`VM`が終了します。

- - - -
[When DISPOSE_ON_CLOSE met WebStart](https://www.pushing-pixels.org/2008/01/14/when-dispose_on_close-met-webstart.html)によると、`Web Start`で実行する場合は`DISPOSE_ON_CLOSE`ではなく`EXIT_ON_CLOSE`を使っておいた方が良さそうです。このため、上記のサンプルでは解説とは異なりコメントアウトしたコードで終了するようになっています。

## 参考リンク
- [AWT のスレッドの問題  (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/doc-files/AWTThreadIssues.html)
- [When DISPOSE_ON_CLOSE met WebStart · Pushing Pixels](https://www.pushing-pixels.org/2008/01/14/when-dispose_on_close-met-webstart.html)

<!-- dummy comment line for breaking list -->

## コメント
- `1`代目の`jframe`から複数の`2`代目の`jframe`を作り出す。また`2`代目の`jframe`から`3`代目の`jframe`を作り出す。適当に選んだ`1`つの`2`代目`jframe`を閉じると、その`2`代目から作り出した`3`代目`jframe`も同時に`dispose`したい。即ち別の`2`代目とそこから生成した`3`代目には影響（`dispose`）を及ぼさないするにはどうすれば宜しいでしょうか？宜しくご教示ください。 -- *Panda* 2011-03-07 (月) 15:12:52
    - ルートになる`JFrame`は`EXIT_ON_CLOSE`、残りは`DISPOSE_ON_CLOSE`とし、各`JFrame`の親子関係をどこかに保持するなどしておけば、あとは閉じる時に自分(`JFrame`)の子も深さ優先で検索して同様に閉じていくだけで特に問題ない？と思います。   -- *aterai* 2011-03-07 (月) 18:58:49

<!-- dummy comment line for breaking list -->
