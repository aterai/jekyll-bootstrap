---
layout: post
category: swing
folder: CellEditorInputVerifier
title: JTableのセルエディタへの入力を検証する
tags: [JTable, CellEditor, InputVerifier, DocumentFilter, JFormattedTextField]
author: aterai
pubdate: 2019-08-05T16:10:21+09:00
description: JTableのセルエディタへの入力が妥当かをInputVerifierなどを使用して検証します。
image: https://drive.google.com/uc?id=1a1Hfeov5wRU2B59t5ea3zVRm8m-6PkLW
comments: true
---
## 概要
`JTable`のセルエディタへの入力が妥当かを`InputVerifier`などを使用して検証します。

{% download https://drive.google.com/uc?id=1a1Hfeov5wRU2B59t5ea3zVRm8m-6PkLW %}

## サンプルコード
<pre class="prettyprint"><code>TableModel model = new DefaultTableModel(columnNames, 10) {
  @Override public Class&lt;?&gt; getColumnClass(int column) {
    return Integer.class;
  }
};
JTable table = new JTable(model) {
  @Override public Component prepareEditor(TableCellEditor editor, int row, int column) { 
    Component c = super.prepareEditor(editor, row, column);
    ((JComponent) c).setBorder(BorderFactory.createEmptyBorder(1, 1, 1, 1));
    return c;
  }
};

JTextField textField2 = new JTextField();
textField2.setInputVerifier(new IntegerInputVerifier());
table.getColumnModel().getColumn(2).setCellEditor(new DefaultCellEditor(textField2) {
  @Override public boolean stopCellEditing() {
    JComponent editor = (JComponent) getComponent();
    boolean isEditValid = editor.getInputVerifier().verify(editor);
    editor.setBorder(isEditValid ? BorderFactory.createEmptyBorder(1, 1, 1, 1)
                                 : BorderFactory.createLineBorder(Color.RED));
    return isEditValid &amp;&amp; super.stopCellEditing();
  }
});
</code></pre>

## 解説
- `Default`
    - デフォルトの`JTable.NumberEditor`(`JTable.GenericEditor`を継承)を使用
    - 数値以外を入力し、<kbd>Enter</kbd>や<kbd>Tab</kbd>キーで編集確定を実行するとエディタの縁が赤くなりフォーカス移動がキャンセルされる
- `DocumentFilter`
    - セルエディタに数値以外の入力を禁止する`DocumentFilter`を`AbstractDocument#setDocumentFilter(...)`でメソッドで設定し、TableColumn#setCellEditor(...)で`1`列目のセルエディタとして設定
- `InputVerifier`
    - セルエディタに`InputVerifier`を設定し、TableColumn#setCellEditor(...)で`2`列目のセルエディタとして設定
    - <kbd>Enter</kbd>や<kbd>Tab</kbd>キーで編集確定する`CellEditor#stopCellEditing()`メソッドを実行したとき、自然数、または空文字以外が入力されている場合はエディタの縁を赤くし、フォーカス移動がキャンセルする
- `JFormattedTextField`
    - セルエディタに`JFormattedTextField`を設定し、TableColumn#setCellEditor(...)で`3`列目のセルエディタとして設定
    - <kbd>Tab</kbd>キーで編集確定する`CellEditor#stopCellEditing()`メソッドを実行したとき、数値以外が入力されている場合はエディタの縁を赤くし、フォーカス移動がキャンセルする
        - デフォルトの`JFormattedTextField`の場合、<kbd>Enter</kbd>キーの入力で`JFormattedTextField`側の`InputMap`で定義されたアクションでフォーカス移動がキャンセルされ、`CellEditor#stopCellEditing()`は実行されないのでエディタの縁は変化しない

<!-- dummy comment line for breaking list -->

- - - -
- <kbd>ESC</kbd>でセルエディタの編集をキャンセルしたときエディタの縁が赤のまま残ってしまう場合があるので、`JTable#prepareEditor(...)`メソッドをオーバーライドして縁を初期化
    
    <pre class="prettyprint"><code>JTable table = new JTable(model) {
      @Override public Component prepareEditor(TableCellEditor editor, int row, int column) { 
        Component c = super.prepareEditor(editor, row, column);
        ((JComponent) c).setBorder(BorderFactory.createEmptyBorder(1, 1, 1, 1));
        return c;
      }
    };
</code></pre>
- * 参考リンク [#reference]
- [JTextFieldの入力を数値に制限する](https://ateraimemo.com/Swing/NumericTextField.html)
- [CellEditorをJSpinnerにして日付を変更](https://ateraimemo.com/Swing/DateCellEditor.html)

<!-- dummy comment line for breaking list -->

## コメント
