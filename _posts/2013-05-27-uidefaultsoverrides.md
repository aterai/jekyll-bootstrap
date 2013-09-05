---
layout: post
title: Nimbusの外観をUIDefaultsで変更する
category: swing
folder: UIDefaultsOverrides
tags: [NimbusLookAndFeel, UIDefaults, Painter]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-05-27

## Nimbusの外観をUIDefaultsで変更する
`NimbusLookAndFeel`の外観を`UIDefaults`を使って部分的に変更します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/-iuOm0KmZLK4/UaIp6IGdL4I/AAAAAAAABso/TUvbvWNNQuI/s800/UIDefaultsOverrides.png)

### サンプルコード
<pre class="prettyprint"><code>UIDefaults d = new UIDefaults();
d.put("TextArea.borderPainter", new Painter() {
  @Override public void paint(Graphics2D g, Object o, int w, int h) {}
});
MultiLineTableCellRenderer r = new MultiLineTableCellRenderer();
r.putClientProperty("Nimbus.Overrides", d);
r.putClientProperty("Nimbus.Overrides.InheritDefaults", false);
</code></pre>

### 解説
- `JCheckBoxMenuItem`
    - `CheckBoxMenuItem[Enabled].checkIconPainter`, `CheckBoxMenuItem[MouseOver].checkIconPainter`, `CheckBoxMenuItem[Enabled+Selected].checkIconPainter`, `CheckBoxMenuItem[MouseOver+Selected].checkIconPainter`の`Painter`(これらの状態を独自に描画)を置き換えた`UIDefaults`を作成し、`putClientProperty("Nimbus.Overrides", d);`を使って上書き
- `JTextArea`
    - `JTable`の`TableCellRenderer`に`JTextArea`を使用してセル内に複数行の文字列を表示([JTableのセルの高さを自動調整](http://terai.xrea.jp/Swing/AutoWrapTableCell.html))
    - `NimbusLookAndFeel`では、`JScrollPane`内にない`JTextArea`には`Border`が表示されるので、これを非表示にするために`TextArea.borderPainter`で使用する`Painter`を置き換えた`UIDefaults`を作成し、`JTextArea`のデフォルトを`putClientProperty("Nimbus.Overrides", d);`を使って上書き
        - `UIManager.getBorder("Table.focusCellHighlightBorder")`を使うと、なぜか一番左上のセルのフォーカスが表示されない
    - `TextArea.NotInScrollPane`の`State#isInState(...)`をオーバーライドして`JScrollPane`内にあるように見せかける方法もある

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>d.put("TextArea.NotInScrollPane", new State("NotInScrollPane") {
  @Override protected boolean isInState(JComponent c) {
    //@see javax.swing.plaf.nimbus.TextAreaNotInScrollPaneState
    //return !(c.getParent() instanceof JViewport);
    return false;
  }
});
r.putClientProperty("Nimbus.Overrides", d);
</code></pre>

### 参考リンク
- [Nimbus Defaults (The Java™ Tutorials > Creating a GUI With JFC/Swing > Modifying the Look and Feel)](http://docs.oracle.com/javase/tutorial/uiswing/lookandfeel/_nimbusDefaults.html)
    - `NimbusLookAndFeel`のプロパティ一覧
- [javax.swing.plaf.nimbus (Java Platform SE 7 )](http://docs.oracle.com/javase/jp/7/api/javax/swing/plaf/nimbus/package-summary.html)
    - [NimbusStyle (Java Platform SE 7 )](http://docs.oracle.com/javase/jp/7/api/javax/swing/plaf/nimbus/NimbusStyle.html)

<!-- dummy comment line for breaking list -->

### コメント