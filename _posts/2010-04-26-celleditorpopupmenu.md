---
layout: post
category: swing
folder: CellEditorPopupMenu
title: JTableのセルエディタにJPopupMenuを設定
tags: [JTable, TableCellEditor, UndoManager, JPopupMenu, AncestorListener]
author: aterai
pubdate: 2010-04-26T16:54:26+09:00
description: JTableのセルエディタに、Copy、Paste、Undo、Redoなどを行うJPopupMenuを設定します。
hreflang:
    href: http://java-swing-tips.blogspot.com/2010/11/jtable-celleditor-popupmenu.html
    lang: en
comments: true
---
## 概要
`JTable`のセルエディタに、`Copy`、`Paste`、`Undo`、`Redo`などを行う`JPopupMenu`を設定します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTIn7Rc6TI/AAAAAAAAATE/drRaDYiUB1w/s800/CellEditorPopupMenu.png %}

## サンプルコード
<pre class="prettyprint"><code>public static JPopupMenu installTextComponentPopupMenu(final JTextComponent tc) {
  final UndoManager manager = new UndoManager();
  final Action undoAction   = new UndoAction(manager);
  final Action redoAction   = new RedoAction(manager);
  final Action cutAction    = new DefaultEditorKit.CutAction();
  final Action copyAction   = new DefaultEditorKit.CopyAction();
  final Action pasteAction  = new DefaultEditorKit.PasteAction();
  final Action deleteAction = new AbstractAction("delete") {
    @Override public void actionPerformed(ActionEvent e) {
      JPopupMenu pop = (JPopupMenu) e.getSource();
      ((JTextComponent) pop.getInvoker()).replaceSelection(null);
    }
  };
  tc.addAncestorListener(new AncestorListener() {
    @Override public void ancestorAdded(AncestorEvent e) {
      manager.discardAllEdits();
      tc.requestFocusInWindow();
    }
    @Override public void ancestorMoved(AncestorEvent e) {}
    @Override public void ancestorRemoved(AncestorEvent e) {}
  });
  tc.getDocument().addUndoableEditListener(manager);
  tc.getActionMap().put("undo", undoAction);
  tc.getActionMap().put("redo", redoAction);
  InputMap imap = tc.getInputMap(JComponent.WHEN_ANCESTOR_OF_FOCUSED_COMPONENT);
  imap.put(KeyStroke.getKeyStroke(KeyEvent.VK_Z, InputEvent.CTRL_DOWN_MASK), "undo");
  imap.put(KeyStroke.getKeyStroke(KeyEvent.VK_Y, InputEvent.CTRL_DOWN_MASK), "redo");

  JPopupMenu popup = new JPopupMenu();
  popup.add(cutAction);
  popup.add(copyAction);
  popup.add(pasteAction);
  popup.add(deleteAction);
  popup.addSeparator();
  popup.add(undoAction);
  popup.add(redoAction);

  popup.addPopupMenuListener(new PopupMenuListener() {
    @Override public void popupMenuCanceled(PopupMenuEvent e) {}
    @Override public void popupMenuWillBecomeInvisible(PopupMenuEvent e) {
      undoAction.setEnabled(true);
      redoAction.setEnabled(true);
    }
    @Override public void popupMenuWillBecomeVisible(PopupMenuEvent e) {
      JPopupMenu pop = (JPopupMenu) e.getSource();
      JTextField field = (JTextField) pop.getInvoker();
      boolean flg = field.getSelectedText() != null;
      cutAction.setEnabled(flg);
      copyAction.setEnabled(flg);
      deleteAction.setEnabled(flg);
      undoAction.setEnabled(manager.canUndo());
      redoAction.setEnabled(manager.canRedo());
    }
  });
  tc.setComponentPopupMenu(popup);
  return popup;
}
</code></pre>

## 解説
上記のサンプルでは、`JTable`のセルエディタに、`Cut`、`Copy`、`Paste`、`Delete`、`Undo`、`Redo`を行う`JPopupMenu`を設定しています。

- - - -
セルエディタとして使用している`JTextField`は、おなじものを使い回しているので、別のセルでの編集が持ち越されないよう、`AncestorListener`を使って表示されるたびに、`UndoManager`を空(`UndoManager#discardAllEdits()`を呼び出す)にしています。

もしくは、`DefaultCellEditor#isCellEditable(...)`などをオーバーライドしてリセットする方法もあります。

<pre class="prettyprint"><code>DefaultCellEditor ce = new DefaultCellEditor(new JTextField()) {
  @Override public boolean isCellEditable(EventObject e) {
    boolean b = super.isCellEditable(e);
    if (b) {
      manager.discardAllEdits();
    }
    return b;
  }
};
table.setDefaultEditor(Object.class, ce);
</code></pre>

## 参考リンク
- [Java Swing「JTable」メモ(Hishidama's Swing-JTable Memo)](http://www.ne.jp/asahi/hishidama/home/tech/java/swing/JTable.html)
    - セルエディタだけではなく、行の追加、削除などを`Undo`、`Redo`するサンプルが参考になります。

<!-- dummy comment line for breaking list -->

## コメント
