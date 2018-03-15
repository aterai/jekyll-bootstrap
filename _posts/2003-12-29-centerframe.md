---
layout: post
category: swing
folder: CenterFrame
title: JFrameをスクリーン中央に表示
tags: [JFrame]
author: aterai
pubdate: 2003-12-29T15:48:20+09:00
description: JFrameやJDialogなどのWindowがスクリーンの中央に配置されるように設定します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTIvEn-69I/AAAAAAAAATQ/Fw4dLY4C0EE/s800/CenterFrame.png
comments: true
---
## 概要
`JFrame`や`JDialog`などの`Window`がスクリーンの中央に配置されるように設定します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTIvEn-69I/AAAAAAAAATQ/Fw4dLY4C0EE/s800/CenterFrame.png %}

## サンプルコード
<pre class="prettyprint"><code>JFrame frame = new JFrame("フレームをスクリーン中央に表示");
frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
frame.getContentPane().add(new MainPanel());
frame.pack();
frame.setLocationRelativeTo(null);
// 以下は自前で位置を計算する場合
// Rectangle screen = frame.getGraphicsConfiguration().getBounds();
// frame.setLocation(screen.x + screen.width  / 2 - frame.getSize().width  / 2,
//                   screen.y + screen.height / 2 - frame.getSize().height / 2);
frame.setVisible(true);
</code></pre>

## 解説
`Window#setLocationRelativeTo(Component)`メソッドで引数で指定した基準となるコンポーネントを`null`にした場合、`JFrame`は画面中央に配置されます。

- `JFrame`の左上隅座標を計算して`JFrame#setLocation(...)`メソッドを使用し、`JFrame`を画面中央に配置する方法もある
    
    <pre class="prettyprint"><code>Rectangle screen = frame.getGraphicsConfiguration().getBounds();
    frame.setLocation(
      screen.x + screen.width / 2 - frame.getSize().width / 2,
      screen.y + screen.height / 2 - frame.getSize().height / 2);
</code></pre>
- どちらの場合も、フレームを`pack()`、もしくは`setSize(int, int)`で`JFrame`のサイズを設定した後で実行する必要がある

<!-- dummy comment line for breaking list -->

## コメント
- `1.4`以降なら、`setLocationRelativeTo(null)`でも中央になりますよ。 -- *Wata* 2004-06-07 (月) 17:47:08
    - こんな方法があるのですね。参考になりました。 -- *aterai* 2004-06-07 (月) 19:26:17
    - というわけで、`src.zip`などを更新してみました。ありがとうございました。 -- *aterai* 2004-06-07 (月) 19:44:21

<!-- dummy comment line for breaking list -->
