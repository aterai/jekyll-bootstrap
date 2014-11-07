---
layout: post
category: swing
folder: ActionMap
title: JTextFieldでコピー、貼り付けなどを禁止
tags: [JTextField, DefaultEditorKit, ActionMap]
author: aterai
pubdate: 2005-07-18
description: JTextFieldへのコピー、貼り付け、切り取りを禁止します。
comments: true
---
## 概要
`JTextField`へのコピー、貼り付け、切り取りを禁止します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTHX8kSixI/AAAAAAAAARE/cRSBUI5TJWo/s800/ActionMap.png %}

## サンプルコード
<pre class="prettyprint"><code>Action beep  = new DefaultEditorKit.BeepAction();
ActionMap am = field.getActionMap();
am.put(DefaultEditorKit.cutAction,   beep);
am.put(DefaultEditorKit.copyAction,  beep);
am.put(DefaultEditorKit.pasteAction, beep);
</code></pre>

## 解説
上記のサンプルでは、`JTextField`の`ActionMap`から、コピーなどの`Action`を取得し、これらをビープ音を鳴らす`DefaultEditorKit.BeepAction()`に置き換えています。

- - - -
以下のように`copy`メソッドなどをオーバーライドする方法もあります。

<pre class="prettyprint"><code>JTextField field = new JTextField() {
  @Override public void copy() {
    UIManager.getLookAndFeel().provideErrorFeedback(this);
    //java.awt.Toolkit.getDefaultToolkit().beep();
  }
};
</code></pre>

## 参考リンク
- [DefaultEditorKitでポップアップメニューからコピー](http://ateraimemo.com/Swing/DefaultEditorKit.html)
- [JComponentのKeyBinding一覧を取得する](http://ateraimemo.com/Swing/KeyBinding.html)

<!-- dummy comment line for breaking list -->

## コメント
