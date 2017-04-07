---
layout: post
category: swing
folder: HTMLColorCodes
title: HTMLの16進数カラーコードからColorを生成する
tags: [HTML, JLabel, Color]
author: aterai
pubdate: 2016-10-31T12:38:51+09:00
description: HTMLの16進数カラーコードからColorを生成して、JLabelの文字色を変更する方法をテストします。
image: https://drive.google.com/uc?export=view&id=1Vm61yca-8zEib19f6hRDxNtoX7gcUP6Ubg
comments: true
---
## 概要
`HTML`の`16`進数カラーコードから`Color`を生成して、`JLabel`の文字色を変更する方法をテストします。

{% download https://drive.google.com/uc?export=view&id=1Vm61yca-8zEib19f6hRDxNtoX7gcUP6Ubg %}

## サンプルコード
<pre class="prettyprint"><code>private MainPanel() {
  super(new BorderLayout());

  Box box = Box.createVerticalBox();
  box.add(makeLabel("new Color(0xff0000)", new Color(0xff0000)));
  box.add(makeLabel("new Color(0x88_88_88)", new Color(0x88_88_88)));
  box.add(makeLabel("new Color(Integer.parseInt(\"00ff00\", 16))",
                    new Color(Integer.parseInt("00ff00", 16))));
  box.add(makeLabel("new Color(Integer.decode(\"#0000ff\"))",
                    new Color(Integer.decode("#0000ff"))));
  box.add(makeLabel("Color.decode(\"#00ffff\")", Color.decode("#00ffff")));

  JLabel label = new JLabel("&lt;html&gt;&lt;span style='color: #ff00ff'&gt;#ff00ff");
  label.setBorder(BorderFactory.createTitledBorder(
      "new JLabel(\"&lt;html&gt;&lt;span style='color: #ff00ff'&gt;#ff00ff\")"));
  box.add(label);
  box.add(Box.createVerticalGlue());

  add(new JScrollPane(box));
  setPreferredSize(new Dimension(320, 240));
}
private static JLabel makeLabel(String title, Color c) {
  JLabel label = new JLabel(String.format("#%06x", c.getRGB() &amp; 0xffffff)) {
    @Override public Dimension getMaximumSize() {
      Dimension d = super.getPreferredSize();
      d.width = Short.MAX_VALUE;
      return d;
    }
  };
  label.setBorder(BorderFactory.createTitledBorder(title));
  label.setForeground(c);
  return label;
}
</code></pre>

## 解説
- `new Color(0xff0000)`
    - 頭に`0x`をつけた`16`進数表記の数値を使用して`Color`を生成
- `new Color(0x88_88_88)`
    - 頭に`0x`をつけた`16`進数表記の数値を使用して`Color`を生成
    - 桁ごとにアンダースコアを挿入して、`16`進数表記数値リテラルの可読性を向上させている
- `new Color(Integer.parseInt("00ff00", 16))`
    - [Integer.parseInt(String, int) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/lang/Integer.html#parseInt-java.lang.String-int-)
    - 基数を`16`進にして`Integer.parseInt(String, int)`を使用し、文字列を整数に変換して`Color`を生成
    - `#00ff00`や`0x00ff00`などは`NumberFormatException`になる
- `new Color(Integer.decode("#0000ff"))`
    - [Integer.decode(String) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/lang/Integer.html#decode-java.lang.String-)
    - `Integer.decode(String)`を使用して、文字列を整数にデコード
    - 基数指定子のない`0000ff`や桁間のアンダースコアがある`0x00_00_ff`は`NumberFormatException`になる
- `Color.decode("#00ffff")`
    - [Color.decode(String) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/Color.html#decode-java.lang.String-)
    - 内部で`Integer.decode(String)`を使用して、文字列を整数にデコードし、`Color`を生成
- `new JLabel("<html><span style='color: #ff00ff'>#ff00ff")`
    - 要素に`style`属性を追加して`CSS`で文字色を指定した`JLabel`を生成

<!-- dummy comment line for breaking list -->

## 参考リンク
- [java - Is it possible to use Color Hex in JLabel like #02f7fc? - Stack Overflow](https://stackoverflow.com/questions/39949076/is-it-possible-to-use-color-hex-in-jlabel-like-02f7fc)

<!-- dummy comment line for breaking list -->

## コメント
