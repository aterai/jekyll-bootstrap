---
layout: post
category: swing
folder: UIDefaultsOverrides
title: Nimbusの外観をUIDefaultsで変更する
tags: [NimbusLookAndFeel, UIDefaults, Painter]
author: aterai
pubdate: 2013-05-27T01:49:34+09:00
description: NimbusLookAndFeelの外観をUIDefaultsを使って部分的に変更します。
image: https://lh4.googleusercontent.com/-iuOm0KmZLK4/UaIp6IGdL4I/AAAAAAAABso/TUvbvWNNQuI/s800/UIDefaultsOverrides.png
comments: true
---
## 概要
`NimbusLookAndFeel`の外観を`UIDefaults`を使って部分的に変更します。

{% download https://lh4.googleusercontent.com/-iuOm0KmZLK4/UaIp6IGdL4I/AAAAAAAABso/TUvbvWNNQuI/s800/UIDefaultsOverrides.png %}

## サンプルコード
<pre class="prettyprint"><code>UIDefaults d = new UIDefaults();
d.put("TextArea.borderPainter", new Painter&lt;JComponent&gt;() {
  @Override public void paint(Graphics2D g, JComponent c, int w, int h) {
    /* Empty painter */
  }
});
MultiLineTableCellRenderer r = new MultiLineTableCellRenderer();
r.putClientProperty("Nimbus.Overrides", d);
r.putClientProperty("Nimbus.Overrides.InheritDefaults", false);
</code></pre>

## 解説
- `JCheckBoxMenuItem`
    - `CheckBoxMenuItem[Enabled].checkIconPainter`、`CheckBoxMenuItem[MouseOver].checkIconPainter`、`CheckBoxMenuItem[Enabled+Selected].checkIconPainter`、`CheckBoxMenuItem[MouseOver+Selected].checkIconPainter`の`Painter`(これらの状態を独自に描画)を置き換えた`UIDefaults`を作成し、`putClientProperty("Nimbus.Overrides", d)`を使用して上書き
- `JTextArea`
    - `JTable`の`TableCellRenderer`に`JTextArea`を使用してセル内に複数行の文字列を表示
        - 参考: [JTableのセルの高さを自動調整](https://ateraimemo.com/Swing/AutoWrapTableCell.html)
    - `NimbusLookAndFeel`では、`JTextArea`が`JScrollPane`内に配置されていない場合、`Border`が表示されるので、これを非表示にするために`TextArea.borderPainter`で使用する`Painter`を置き換えた`UIDefaults`を作成し、`JTextArea`のデフォルトを`putClientProperty("Nimbus.Overrides", d)`を使って上書き
        - `UIManager.getBorder("Table.focusCellHighlightBorder")`を使うと、なぜか一番左上のセルのフォーカスが表示されない
    - `TextArea.NotInScrollPane`の`State#isInState(...)`をオーバーライドして`JScrollPane`内にあるように見せかける方法もある
        
        <pre class="prettyprint"><code>d.put("TextArea.NotInScrollPane", new State("NotInScrollPane") {
          @Override protected boolean isInState(JComponent c) {
            // @see javax.swing.plaf.nimbus.TextAreaNotInScrollPaneState
            // return !(c.getParent() instanceof JViewport);
            return false;
          }
        });
        r.putClientProperty("Nimbus.Overrides", d);
</code></pre>
    - * 参考リンク [#reference]
- [Nimbus Defaults (The Java™ Tutorials > Creating a GUI With JFC/Swing > Modifying the Look and Feel)](https://docs.oracle.com/javase/tutorial/uiswing/lookandfeel/_nimbusDefaults.html)
    - `NimbusLookAndFeel`のプロパティ一覧
- [javax.swing.plaf.nimbus (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/plaf/nimbus/package-summary.html)
    - [NimbusStyle (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/plaf/nimbus/NimbusStyle.html)

<!-- dummy comment line for breaking list -->

## コメント
