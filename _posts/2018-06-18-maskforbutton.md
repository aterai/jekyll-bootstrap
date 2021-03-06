---
layout: post
category: swing
folder: MaskForButton
title: JTabbedPaneのタブをマウスの中ボタンクリックで閉じる
tags: [JTabbedPane, MouseListener, InputEvent]
author: aterai
pubdate: 2018-06-18T16:22:26+09:00
description: JTabbedPaneのタブをマウスの中(ホイール)ボタンクリックなどで閉じるよう設定します。
image: https://drive.google.com/uc?id=1vZI_GTDVvkzH3DmnWXC2h1NPU1mSmuBzGQ
comments: true
---
## 概要
`JTabbedPane`のタブをマウスの中(ホイール)ボタンクリックなどで閉じるよう設定します。

{% download https://drive.google.com/uc?id=1vZI_GTDVvkzH3DmnWXC2h1NPU1mSmuBzGQ %}

## サンプルコード
<pre class="prettyprint"><code>tabbedPane.addMouseListener(new MouseAdapter() {
  @Override public void mouseClicked(MouseEvent e) {
    int button = e.getButton();
    boolean isB1Double = e.getClickCount() == 2 &amp;&amp; button == 1;
    boolean isB2Down = MouseInfo.getNumberOfButtons() &gt; 2 &amp;&amp; button == 2;
    JTabbedPane tabbedPane = (JTabbedPane) e.getComponent();
    int idx = tabbedPane.indexAtLocation(e.getX(), e.getY());
    if (idx &gt;= 0 &amp;&amp; (isB2Down || isB1Double)) {
      tabbedPane.remove(idx);
    }
  }

  @Override public void mousePressed(MouseEvent e) {
    System.out.println("BUTTON2 mousePressed: "
      + Objects.toString((e.getModifiersEx() &amp; InputEvent.getMaskForButton(2)) != 0));
  }

  @Override public void mouseReleased(MouseEvent e) {
    System.out.println("BUTTON2 mouseReleased: "
      + Objects.toString((e.getModifiersEx() &amp; InputEvent.getMaskForButton(2)) != 0));
  }
});
</code></pre>

## 解説
- 中ボタンでクリック
    - `MouseListener#mouseClicked(...)`内の場合、`MouseEvent#getButton()`で状態が変化したマウスボタンを取得しそれが第`2`ボタンかどうかで判断する
    - `MouseListener#mousePressed(...)`内なら`e.getModifiersEx() & InputEvent.getMaskForButton(2)`でフラグが立っているかどうかで判断可能
    - `MouseInfo.getNumberOfButtons()`メソッドで取得されるマウスのボタン数が`2`以下の場合、中ボタンは無い(未検証)と判断している
- 左ボタンでダブルクリック
    - `MouseEvent#getClickCount()`が`2`、かつ`MouseEvent#getButton()`が第`1`ボタンの場合、タブを閉じる

<!-- dummy comment line for breaking list -->

## 参考リンク
- [InputEvent#getMaskForButton(int) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/event/InputEvent.html#getMaskForButton-int-)
- [MouseInfo#getNumberOfButtons() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/MouseInfo.html#getNumberOfButtons--)

<!-- dummy comment line for breaking list -->

## コメント
