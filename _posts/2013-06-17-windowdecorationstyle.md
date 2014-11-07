---
layout: post
category: swing
folder: WindowDecorationStyle
title: JRootPaneにリサイズのための装飾を設定する
tags: [JFrame, JRootPane, JLayeredPane, JInternalFrame, MetalLookAndFeel]
author: aterai
pubdate: 2013-06-17T02:37:17+09:00
description: JFrame自体の装飾を削除し、JRootPaneにリサイズのためのウィンドウ装飾(透明)を設定します。
comments: true
---
## 概要
`JFrame`自体の装飾を削除し、`JRootPane`にリサイズのためのウィンドウ装飾(透明)を設定します。

{% download https://lh3.googleusercontent.com/-6jloCHHvTmw/Ub30100G84I/AAAAAAAABuM/AHxMNa5jyB0/s800/WindowDecorationStyle.png %}

## サンプルコード
<pre class="prettyprint"><code>JFrame frame = new JFrame();
try{
  UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
}catch(Exception e) {
  e.printStackTrace();
}
//XXX: JFrame frame = new JFrame();
frame.setUndecorated(true);

JRootPane root = frame.getRootPane();
root.setWindowDecorationStyle(JRootPane.PLAIN_DIALOG);
JLayeredPane layeredPane = root.getLayeredPane();
Component c = layeredPane.getComponent(1);
if(c instanceof JComponent) {
  JComponent orgTitlePane = (JComponent)c;
  orgTitlePane.setVisible(false);
  //layeredPane.remove(orgTitlePane);
}
//JComponent dummyTitlePane = new JLabel();
//layeredPane.add(dummyTitlePane, JLayeredPane.FRAME_CONTENT_LAYER);
//dummyTitlePane.setVisible(true);

JPanel p = new JPanel(new BorderLayout());
p.setBorder(BorderFactory.createEmptyBorder(2,2,2,2));
p.setBackground(new Color(1f,1f,1f,.01f));

p.add(internalFrame);
frame.getContentPane().add(p);
</code></pre>

## 解説
- `JFrame`の装飾を削除
    - `JFrame#setUndecorated(true);`
- `JInternalFrame`を`ContentPane`に追加
    - [JInternalFrameをJFrameとして表示する](http://ateraimemo.com/Swing/InternalFrameTitleBar.html)
    - `JFrame`の背景色を`JFrame#setBackground(new Color(0,0,0,0));`で透明化
- `JRootPane`に装飾を追加、変更
    - `JRootPane#setWindowDecorationStyle(JRootPane.PLAIN_DIALOG);`で装飾を追加し、リサイズのための`MouseMotionListener`などを利用
        - [JFrameのタイトルバーなどの装飾を独自のものにカスタマイズする](http://ateraimemo.com/Swing/CustomDecoratedFrame.html)は、このリサイズのための`MouseMotionListener`も独自に追加している
    - `JLayeredPane`からタイトルバーを削除
        - 上辺でリサイズできない
    - マウスでリサイズ可能な領域を作成するために、`ContentPane`にほぼ透明な`Border`をもつ`JPanel`を追加

<!-- dummy comment line for breaking list -->

- - - -
- `MetalLookAndFeel`のみ`LookAndFeel#getSupportsWindowDecorations()`が`true`
    - `LookAndFeel`を変更する場合は、`ContentPane`以下から更新することで、`JRootPane#setWindowDecorationStyle(JRootPane.PLAIN_DIALOG);`が無効にならないようにする必要がある

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>for(Window window: Frame.getWindows()) {
  if(window instanceof RootPaneContainer) {
    RootPaneContainer rpc = (RootPaneContainer)window;
    SwingUtilities.updateComponentTreeUI(rpc.getContentPane());
  }
}
</code></pre>

## 参考リンク
- [JInternalFrameをJFrameとして表示する](http://ateraimemo.com/Swing/InternalFrameTitleBar.html)
- [JFrameのタイトルバーなどの装飾を独自のものにカスタマイズする](http://ateraimemo.com/Swing/CustomDecoratedFrame.html)

<!-- dummy comment line for breaking list -->

## コメント
