---
layout: post
title: JComponentのKeyBinding一覧を取得する
category: swing
folder: KeyBinding
tags: [JComponent, ActionMap, InputMap]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-08-18

## JComponentのKeyBinding一覧を取得する
`JComponent`から、`ActionMap`、`InputMap`を取得し、`KeyBinding`の一覧表を作成します。[ftp://ftp.oreilly.de/pub/examples/english_examples/jswing2/code/goodies/misc.html Miscellaneous Tools - Java Swing Utilities]の[ftp://ftp.oreilly.de/pub/examples/english_examples/jswing2/code/goodies/Mapper.java Mapper.java]を元に`UI`を変更しています。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTO1Qi0Y2I/AAAAAAAAAdA/yMsuc2sjSKg/s800/KeyBinding.png)

### サンプルコード
<pre class="prettyprint"><code>final List&lt;Integer&gt; focusType = Arrays.asList(
        JComponent.WHEN_FOCUSED, JComponent.WHEN_IN_FOCUSED_WINDOW,
        JComponent.WHEN_ANCESTOR_OF_FOCUSED_COMPONENT);
table.setAutoCreateRowSorter(true);
JPanel p = new JPanel(new GridLayout(2,1,5,5));
p.setBorder(BorderFactory.createEmptyBorder(5,5,5,5));
p.add(componentChoices);
p.add(new JButton(new AbstractAction("show") {
  @Override public void actionPerformed(ActionEvent e) {
    model.setRowCount(0);
    JComponent c = ((JComponentType)componentChoices.getSelectedItem()).component;
    for(Integer f:focusType) {
      loadBindingMap(f, c.getInputMap(f), c.getActionMap());
    }
  }
}));
</code></pre>

### 解説
上記のサンプルでは、`JComboBox`で選択されたコンポーネントに割り当てられているデフォルトの`KeyBinding`を、`JTable`に表示することができます。

### 参考リンク
- [ftp://ftp.oreilly.de/pub/examples/english_examples/jswing2/code/goodies/misc.html Miscellaneous Tools - Java Swing Utilities]
    - [ftp://ftp.oreilly.de/pub/examples/english_examples/jswing2/code/goodies/Mapper.java Mapper.java]
- [How to Use Key Bindings (The Java™ Tutorials)](http://docs.oracle.com/javase/tutorial/uiswing/misc/keybinding.html)

<!-- dummy comment line for breaking list -->

### コメント
- メールで質問があったので: このサンプルは、`properties.xml`の、`compile.source`を`1.5`にして、`MainPanel.java`の`table.setAutoCreateRowSorter(true);`をコメントアウトすれば、`JDK 1.5`でも動作するはずです。 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-08-18 (月) 11:17:11

<!-- dummy comment line for breaking list -->

