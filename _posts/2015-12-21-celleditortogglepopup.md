---
layout: post
category: swing
folder: CellEditorTogglePopup
title: JComboBoxセルエディタのドロップダウンリストを編集開始直後は表示しないよう設定する
tags: [JTable, JComboBox, TableCellEditor, AncestorListener]
author: aterai
pubdate: 2015-12-21T00:46:38+09:00
description: JTableのセルエディタとしてJComboBoxを設定し、そのセルを編集開始した場合、すぐにはドロップダウンリストを表示せず、選択状態になるように変更します。
image: https://lh3.googleusercontent.com/-F2cSZ7OFy4Y/VnbEpVP-sUI/AAAAAAAAOJc/L25fo3nesxE/s800-Ic42/CellEditorTogglePopup.png
comments: true
---
## 概要
`JTable`のセルエディタとして`JComboBox`を設定し、そのセルを編集開始した場合、すぐにはドロップダウンリストを表示せず、選択状態になるように変更します。

{% download https://lh3.googleusercontent.com/-F2cSZ7OFy4Y/VnbEpVP-sUI/AAAAAAAAOJc/L25fo3nesxE/s800-Ic42/CellEditorTogglePopup.png %}

## サンプルコード
<pre class="prettyprint"><code>JComboBox&lt;String&gt; combo = new JComboBox&lt;&gt;(model);
combo.addAncestorListener(new AncestorListener() {
  @Override public void ancestorAdded(final AncestorEvent e) {
    System.out.println("ancestorAdded");
    e.getComponent().setEnabled(false);
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        System.out.println("invokeLater");
        e.getComponent().setEnabled(true);
      }
    });
  }
  @Override public void ancestorRemoved(AncestorEvent e) {}
  @Override public void ancestorMoved(AncestorEvent e) {}
});
table.getColumnModel().getColumn(1).setCellEditor(new DefaultCellEditor(combo));
</code></pre>

## 解説
- `Default`
    - デフォルトの`JComboBox`でセルエディタを作成し、そのセルで`mousePressed(...)`イベントが発生する
    - 別の列のフォーカスが存在する、または全セルにフォーカスが存在しない場合、ドロップダウンリストが表示される
    - 同じ列にフォーカスが存在する場合、選択状態になる(ドロップダウンリストは表示されない)
- `setEnabled`
    - 動作を統一するために、初回は常に選択状態になるように設定する
    - `BasicComboPopup.Handler#mousePressed(...)`で、マウス左ボタンで`JComboBox#isEnabled()==true`の場合は、`BasicComboPopup#togglePopup()`が実行される
    - そのため、セルエディタとして設定する`JComboBox`に`AncestorListener`を追加
    - 編集開始で`JTable`にこのセルエディタが追加され、`AncestorListener#ancestorAdded(...)`が発生するが、`JComboBox#setEnabled(false)`として、`BasicComboPopup#togglePopup()`が実行されないようにブロック
    - `EventQueue.invokeLater(...)`を使用して、マウス操作による一連のイベントの最後に`JComboBox#setEnabled(true)`を設定し、すでに編集開始状態にある同セルをもう一度押すとドロップダウンリストが表示されるように設定

<!-- dummy comment line for breaking list -->

## 参考リンク
- [java - JTable with JCombobox editor: handle mouse clicks - Stack Overflow](https://stackoverflow.com/questions/34284553/jtable-with-jcombobox-editor-handle-mouse-clicks)
- [JTableのCellEditorにJComboBoxを設定](https://ateraimemo.com/Swing/ComboCellEditor.html)

<!-- dummy comment line for breaking list -->

## コメント
