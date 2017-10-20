---
layout: post
category: swing
folder: ImmovableFrame
title: JInternalFrameを固定
tags: [JInternalFrame, MouseMotionListener]
author: aterai
pubdate: 2005-10-10T17:53:41+09:00
description: JInternalFrameをマウスなどで移動できないように固定します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTOXXz-C5I/AAAAAAAAAcQ/0qYBPzKq7js/s800/ImmovableFrame.png
comments: true
---
## 概要
`JInternalFrame`をマウスなどで移動できないように固定します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTOXXz-C5I/AAAAAAAAAcQ/0qYBPzKq7js/s800/ImmovableFrame.png %}

## サンプルコード
<pre class="prettyprint"><code>BasicInternalFrameUI ui = (BasicInternalFrameUI) immovableFrame.getUI();
Component titleBar = ui.getNorthPane();
for (MouseMotionListener l: titleBar.getListeners(MouseMotionListener.class)) {
  titleBar.removeMouseMotionListener(l);
}
</code></pre>

## 解説
`JInternalFrame`の`MouseMotionListener`をすべて削除することで、マウスによる移動を不可能にしています。

- - - -
以下のように、タイトルバー自体を削除して移動できないフレームを作成する方法もあります。

<pre class="prettyprint"><code>ui.setNorthPane(null);
internalframe.setBorder(BorderFactory.createEmptyBorder());
internalframe.setSize(200, 50);
internalframe.add(new JLabel("移動できないフレーム", SwingConstants.CENTER));
internalframe.setLocation(10, 10);
internalframe.pack();
</code></pre>

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTOZ803FiI/AAAAAAAAAcU/Bj1t9F8ZKqI/s800/ImmovableFrame1.png)

## 参考リンク
- [BasicInternalFrameUI#getNorthPane() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/plaf/basic/BasicInternalFrameUI.html#getNorthPane--)
- [Swing - Lock JInternalPane](https://community.oracle.com/thread/1392111)

<!-- dummy comment line for breaking list -->

## コメント
