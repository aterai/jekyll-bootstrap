---
layout: post
title: JFrameをスクリーン中央に表示
category: swing
folder: CenterFrame
tags: [JFrame]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2003-12-29

## JFrameをスクリーン中央に表示
フレームやダイアログなどをスクリーンの中央に表示します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTIvEn-69I/AAAAAAAAATQ/Fw4dLY4C0EE/s800/CenterFrame.png)

### サンプルコード
<pre class="prettyprint"><code>JFrame frame = new JFrame("フレームをスクリーン中央に表示");
frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
frame.getContentPane().add(new MainPanel());
frame.pack();
frame.setLocationRelativeTo(null);
//以下は自前で位置を計算する場合
//Rectangle screen = frame.getGraphicsConfiguration().getBounds();
//frame.setLocation(screen.x + screen.width/2  - frame.getSize().width/2,
//                  screen.y + screen.height/2 - frame.getSize().height/2);
frame.setVisible(true);
</code></pre>

### 解説
`JFrame#setLocationRelativeTo`メソッドで、基準となる親ウィンドウを`null`にすると、そのフレームは画面中央に表示されます。

`JFrame#setLocation`メソッドで任意の位置を指定する場合は、フレームの左上隅座標を計算します。

どちらも、フレームを`pack()`、もしくは`setSize(int,int)`した後で実行するようにしてください。

### コメント
- `1.4`以降なら、`setLocationRelativeTo(null)`でも中央になりますよ。 -- [Wata](http://terai.xrea.jp/Wata.html) 2004-06-07 (月) 17:47:08
    - こんな方法があったんですね。参考になりました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2004-06-07 (月) 19:26:17
    - というわけで、`src.zip`などを更新してみました。ありがとうございました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2004-06-07 (月) 19:44:21

<!-- dummy comment line for breaking list -->

