---
layout: post
category: swing
folder: ComboCellRenderer
title: JTableのCellRendererにJComboBoxを設定
tags: [JTable, JComboBox, TableCellRenderer, TableCellEditor]
author: aterai
pubdate: 2007-03-19T02:32:35+09:00
description: JTableのCellRendererとしてJComboBoxを使用します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTJ35Po_yI/AAAAAAAAAVE/z4Jn6Mv7-pc/s800/ComboCellRenderer.png
comments: true
---
## 概要
`JTable`の`CellRenderer`として`JComboBox`を使用します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTJ35Po_yI/AAAAAAAAAVE/z4Jn6Mv7-pc/s800/ComboCellRenderer.png %}

## サンプルコード
<pre class="prettyprint"><code>class ComboCellRenderer extends JComboBox implements TableCellRenderer {
  private static final Color ec = new Color(240, 240, 255);
  private final JTextField editor;
  public ComboCellRenderer() {
    super();
    setEditable(true);
    setBorder(BorderFactory.createEmptyBorder());

    editor = (JTextField) getEditor().getEditorComponent();
    editor.setBorder(BorderFactory.createEmptyBorder());
    editor.setOpaque(true);
  }
  @Override public Component getTableCellRendererComponent(JTable table,
      Object value, boolean isSelected, boolean hasFocus, int row, int column) {
    removeAllItems();
    if (isSelected) {
      editor.setForeground(table.getSelectionForeground());
      editor.setBackground(table.getSelectionBackground());
    } else {
      editor.setForeground(table.getForeground());
      editor.setBackground((row % 2 == 0) ? ec : table.getBackground());
    }
    addItem(Objects.toString(value, ""));
    return this;
  }
}
</code></pre>

## 解説
上記のサンプルでは、`1`列目(中央)のセルの表示を`JComboBox`にするために、これを継承するセルレンダラーを設定しています。この列はセルエディタも`JComboBox`ですが、セルレンダラーとは別の`JComboBox`のインスタンスを使用しています。

セルレンダラーで使用する`JComboBox`は、セルの表示のみに使用するため、以下のように設定しています。

- 表示用のアイテム(文字列)を一つだけ持つ
- 編集可にして`EditorComponent`の背景色などを他のセルと同様になるように変更
- セル内にきれいに収まるように余白を`0`に設定

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTableのCellEditorにJComboBoxを設定](https://ateraimemo.com/Swing/ComboCellEditor.html)

<!-- dummy comment line for breaking list -->

## コメント
- セルの幅を大きくするとセルの表示が消えますが・・・これは一体なんでしょうか？ -- *ichikawa* 2010-11-01 (月) 23:09:02
    - ご指摘ありがとうございます。リサイズなどでセルの表示がおかしくなるのは、バグです。`DefaultTableCellRenderer#invalidate()`などと同じ(パフォーマンス上の理由)にするため、何もしないようにオーバーライドした、テスト中のコードとサンプルを誤ってアップロードしていました。 -- *aterai* 2010-11-02 (火) 14:23:32

<!-- dummy comment line for breaking list -->
