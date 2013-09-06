---
layout: post
title: JInternalFrameを固定
category: swing
folder: ImmovableFrame
tags: [JInternalFrame, MouseMotionListener]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-10-10

## JInternalFrameを固定
`JInternalFrame`をマウスなどで移動できないように固定します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTOXXz-C5I/AAAAAAAAAcQ/0qYBPzKq7js/s800/ImmovableFrame.png)

### サンプルコード
<pre class="prettyprint"><code>BasicInternalFrameUI ui = (BasicInternalFrameUI)immovableFrame.getUI();
Component titleBar = ui.getNorthPane();
for(MouseMotionListener l:titleBar.getListeners(MouseMotionListener.class)) {
  titleBar.removeMouseMotionListener(l);
}
</code></pre>

### 解説
`JInternalFrame`の`MouseMotionListener`をすべて削除することで、マウスによる移動を不可能にしています。

- - - -
以下のようにしてタイトルバー自体を削除して移動できないフレームを作成する方法もあります。

<pre class="prettyprint"><code>ui.setNorthPane(null);
internalframe.setBorder(BorderFactory.createEmptyBorder());
internalframe.setSize(200,50);
internalframe.add(new JLabel("移動できないフレーム", SwingConstants.CENTER));
internalframe.setLocation(10,10);
internalframe.pack();
</code></pre>

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTOZ803FiI/AAAAAAAAAcU/Bj1t9F8ZKqI/s800/ImmovableFrame1.png)

### 参考リンク
- [Swing - Lock JInternalPane](https://forums.oracle.com/thread/1392111)

<!-- dummy comment line for breaking list -->

### コメント
