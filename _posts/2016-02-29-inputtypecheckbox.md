---
layout: post
category: swing
folder: InputTypeCheckBox
title: JLabelにHTMLフォーマットのinputタグで生成したcheckboxを表示する
tags: [JLabel, HTML, JTableHeader, JCheckBox, NimbusLookAndFeel]
author: aterai
pubdate: 2016-02-29T00:30:08+09:00
description: JLabelを継承するヘッダのTableCellRendererにHTMLフォーマットのinputタグで生成したcheckboxを表示し、クリックに応じてその状態を変更します。
image: https://lh3.googleusercontent.com/-vnWIjLh4mRA/VtMSSVOc3gI/AAAAAAAAOPo/41aAmP3gMuc/s800-Ic42/InputTypeCheckBox.png
comments: true
---
## 概要
`JLabel`を継承するヘッダの`TableCellRenderer`に`HTML`フォーマットの`input`タグで生成した`checkbox`を表示し、クリックに応じてその状態を変更します。

{% download https://lh3.googleusercontent.com/-vnWIjLh4mRA/VtMSSVOc3gI/AAAAAAAAOPo/41aAmP3gMuc/s800-Ic42/InputTypeCheckBox.png %}

## サンプルコード
<pre class="prettyprint"><code>class HeaderRenderer implements TableCellRenderer {
  private static String INPUT = "&lt;html&gt;&lt;table cellpadding='0' cellspacing='0'&gt;"
                              + "&lt;td&gt;&lt;input type='checkbox'&gt;&lt;td&gt;&amp;nbsp;Check All";
  @Override public Component getTableCellRendererComponent(
      JTable table, Object value, boolean isSelected, boolean hasFocus,
      int row, int column) {
    TableCellRenderer r = table.getTableHeader().getDefaultRenderer();
    JLabel l = (JLabel) r.getTableCellRendererComponent(
        table, INPUT, isSelected, hasFocus, row, column);
    for (Component c : l.getComponents()) {
      updateCheckBox(((Container) c).getComponent(0), value);
    }
    return l;
  }
  private static void updateCheckBox(Component c, Object value) {
    if (c instanceof JCheckBox) {
      JCheckBox check = (JCheckBox) c;
      check.setOpaque(false);
      check.setBorder(BorderFactory.createEmptyBorder());
      //check.setText("Check All");
      if (value instanceof Status) {
        switch ((Status) value) {
        case SELECTED:
          check.setSelected(true);
          check.setEnabled(true);
          break;
        case DESELECTED:
          check.setSelected(false);
          check.setEnabled(true);
          break;
        case INDETERMINATE:
          check.setSelected(true);
          check.setEnabled(false);
          break;
        default:
          throw new AssertionError("Unknown Status");
        }
      }
    }
  }
}
</code></pre>

## 解説
`NimbusLookAndFeel`で[JTableHeaderにJCheckBoxを追加してセルの値を切り替える](https://ateraimemo.com/Swing/TableHeaderCheckBox.html)のように`JCheckBox`をアイコン化し、これをヘッダセルレンダラーに`JLabel#setIcon(...)`を使用して設定すると、ソートアイコンの設定と干渉(ソートを使用しない場合でも)して意図した表示にならない場合があります。このサンプルでは、代わりに`HTML`フォーマットの`<input type='checkbox'>`タグを`JLabel#setText(...)`メソッドで設定してチェックボックスを表示しています。

- `<input>`要素の`checked`属性を使用して選択状態の`JCheckBox`を表示可能だが、`disabled`属性で無効状態にできない
- 代わりに、`HTML`コンポーネントのレンダリングを行うコンポーネントを`JLabel`から取得し、その子要素から`JCheckBox`自体を取得して、直接`JCheckBox#setEnabled(...)`、`JCheckBox#setSelected(...)`で状態を変更
    - 参考: [java - Listening to HTML check boxes in jTextPane (or an alternative)? - Stack Overflow](https://stackoverflow.com/questions/7958378/listening-to-html-check-boxes-in-jtextpane-or-an-alternative)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [java - Listening to HTML check boxes in jTextPane (or an alternative)? - Stack Overflow](https://stackoverflow.com/questions/7958378/listening-to-html-check-boxes-in-jtextpane-or-an-alternative)
- [JTableHeaderにJCheckBoxを追加してセルの値を切り替える](https://ateraimemo.com/Swing/TableHeaderCheckBox.html)

<!-- dummy comment line for breaking list -->

## コメント
