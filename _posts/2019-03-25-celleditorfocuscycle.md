---
layout: post
category: swing
folder: CellEditorFocusCycle
title: JTableのセルエディタ内でタブキーによるフォーカス移動を有効にする
tags: [JTable, TableCellEditor, Focus, FocusTraversalPolicy]
author: aterai
pubdate: 2019-03-25T17:24:54+09:00
description: JTableが編集中の場合はセルエディタ内でタブキーによるフォーカス移動が可能になるよう設定します。
image: https://drive.google.com/uc?id=1m3-6T_FyHa51fARDyoZ92MJKfAVox1HjjQ
hreflang:
    href: https://java-swing-tips.blogspot.com/2019/07/enable-focus-move-by-tab-key-in-cell.html
    lang: en
comments: true
---
## 概要
`JTable`が編集中の場合はセルエディタ内でタブキーによるフォーカス移動が可能になるよう設定します。

{% download https://drive.google.com/uc?id=1m3-6T_FyHa51fARDyoZ92MJKfAVox1HjjQ %}

## サンプルコード
<pre class="prettyprint"><code>JTable table = makeTable();
ActionMap am = table.getActionMap();
Action sncc = am.get("selectNextColumnCell");
Action action = new AbstractAction() {
  @Override public void actionPerformed(ActionEvent e) {
    if (!table.isEditing() || !isEditorFocusCycle(table.getEditorComponent())) {
      // System.out.println("Exit editor");
      sncc.actionPerformed(e);
    }
  }
};
am.put("selectNextColumnCell2", action);

InputMap im = table.getInputMap(JComponent.WHEN_ANCESTOR_OF_FOCUSED_COMPONENT);
im.put(KeyStroke.getKeyStroke(KeyEvent.VK_TAB, 0), "selectNextColumnCell2");
// ...
protected boolean isEditorFocusCycle(Component editor) {
  Component child = CheckBoxesEditor.getEditorFocusCycleAfter(editor);
  if (child != null) {
    child.requestFocus();
    return true;
  }
  return false;
}
// ...
public static Component getEditorFocusCycleAfter(Component editor) {
  Component fo = KeyboardFocusManager.getCurrentKeyboardFocusManager().getFocusOwner();
  if (fo == null || !(editor instanceof Container)) {
    return null;
  }
  Container root = (Container) editor;
  if (!root.isFocusCycleRoot()) {
    root = root.getFocusCycleRootAncestor();
  }
  if (root == null) {
    return null;
  }
  // System.out.println("FocusCycleRoot: " + root.getClass().getName());
  FocusTraversalPolicy ftp = root.getFocusTraversalPolicy();
  Component child = ftp.getComponentAfter(root, fo);
  if (child != null &amp;&amp; SwingUtilities.isDescendingFrom(child, editor)) {
    // System.out.println("requestFocus: " + child.getClass().getName());
    // child.requestFocus();
    return child;
  }
  return null;
}
</code></pre>

## 解説
- 上: デフォルトの`JTable`
    - `KeyEvent.VK_TAB`には`selectNextColumnCell`アクションが割り当てられており、このアクションは`table.getCellEditor().stopCellEditing()`メソッドで編集を中断して次のセルを選択する
- 下: `selectNextColumnCell`アクションを置換
    - セルエディタが複数の子コンポーネントを持つ`FocusCycleRoot`コンポーネントであり、そのセルが編集中の場合は`FocusTraversalPolicy`を取得してセル内でフォーカス移動、編集中でない場合は`selectNextColumnCell`アクションを実行するアクションを作成して、`KeyEvent.VK_TAB`に割り当てる
    - このサンプルでは<kbd>Shift+Tab</kbd>での逆順フォーカス移動には対応していないので、編集が中断されて前のセルにフォーカスが移動する

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTableの列にEnumSetを使用する](https://ateraimemo.com/Swing/EnumSet.html)

<!-- dummy comment line for breaking list -->

## コメント
