---
layout: post
category: swing
folder: OptionPaneBackground
title: JOptionPaneの背景色を変更する
tags: [JOptionPane, JPanel]
author: aterai
pubdate: 2020-04-27T18:44:33+09:00
description: JOptionPaneで使用されている子JPanelをすべて透明化して背景色を指定した色に変更します。
image: https://drive.google.com/uc?id=1jUaaox2WyFYAqVow6MbfH7o9rGY-7WqC
comments: true
---
## 概要
`JOptionPane`で使用されている子`JPanel`をすべて透明化して背景色を指定した色に変更します。

{% download https://drive.google.com/uc?id=1jUaaox2WyFYAqVow6MbfH7o9rGY-7WqC %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("OptionPane.background", Color.LIGHT_GRAY);
String txt = "&lt;html&gt;JOptionPane:&lt;br&gt;&lt;li&gt;messageArea&lt;li&gt;realBody&lt;li&gt;separator&lt;li&gt;body&lt;li&gt;buttonArea";
String title = "Title";
int type = JOptionPane.WARNING_MESSAGE;

JLabel label = new JLabel(txt);
label.addHierarchyListener(e -&gt; {
  Component c = e.getComponent();
  if ((e.getChangeFlags() &amp; HierarchyEvent.SHOWING_CHANGED) != 0 &amp;&amp; c.isShowing()) {
    stream(SwingUtilities.getAncestorOfClass(JOptionPane.class, c))
        .filter(JPanel.class::isInstance)
        .map(JPanel.class::cast) // TEST: .peek(cc -&gt; System.out.println(cc.getName()))
        .forEach(p -&gt; p.setOpaque(false));
  }
});

JButton b2 = new JButton("background");
b2.addActionListener(e -&gt; JOptionPane.showMessageDialog(b2.getRootPane(), label, title, type));
</code></pre>

## 解説
- `default`
    - `UIManager.put("OptionPane.background", Color.LIGHT_GRAY)`で`JOptionPane`の背景色を変更
    - `JOptionPane`で使用されている子`JPanel`が不透明のため、フチの色のみ変更される
- `background`
    - `UIManager.put("OptionPane.background", Color.LIGHT_GRAY)`で`JOptionPane`の背景色を変更
    - メッセージ用コンポーネントに`HierarchyListener`を追加して`JOptionPane`のオープンイベントを取得
    - `JOptionPane`が表示状態になったらその子`JPanel`を検索し、すべて`setOpaque(false)`で透明化
    - デフォルトの`JOptionPane`は以下の名前の`5`つの`JPanel`で構成されている
        - `OptionPane.messageArea`
        - `OptionPane.realBody`
        - `OptionPane.separator`
        - `OptionPane.body`
        - `OptionPane.buttonArea`
- `override`
    - `JOptionPane.paintComponent(...)`をオーバーライドして背景を任意の`Texture`に変更
    - `JOptionPane`の子`JPanel`を検索し、すべて`setOpaque(false)`で透明化

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JOptionPaneのデフォルトフォーカス](https://ateraimemo.com/Swing/OptionPaneDefaultFocus.html)
- [java - JOptionPane Background Color - Stack Overflow](https://stackoverflow.com/questions/61252239/joptionpane-background-color/61264104)

<!-- dummy comment line for breaking list -->

## コメント
