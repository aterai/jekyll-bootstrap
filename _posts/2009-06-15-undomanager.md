---
layout: post
category: swing
folder: UndoManager
title: UndoManagerでJTextFieldのUndo、Redoを行う
tags: [JTextField, JTextComponent, UndoManager, ActionMap, Document]
author: aterai
pubdate: 2009-06-15T13:35:15+09:00
description: JTextFieldのドキュメントにUndoManagerを追加して、Undo、Redoを行います。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTWX1uwgqI/AAAAAAAAApI/zvwc9TUlj4E/s800/UndoManager.png
comments: true
---
## 概要
`JTextField`のドキュメントに`UndoManager`を追加して、`Undo`、`Redo`を行います。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTWX1uwgqI/AAAAAAAAApI/zvwc9TUlj4E/s800/UndoManager.png %}

## サンプルコード
<pre class="prettyprint"><code>private static void initUndoRedo(JTextComponent tc) {
  UndoManager manager = new UndoManager();
  tc.getDocument().addUndoableEditListener(manager);
  tc.getActionMap().put("undo", new UndoAction(manager));
  tc.getActionMap().put("redo", new RedoAction(manager));
  InputMap imap = tc.getInputMap(JComponent.WHEN_ANCESTOR_OF_FOCUSED_COMPONENT);
  imap.put(KeyStroke.getKeyStroke(
    KeyEvent.VK_Z, Toolkit.getDefaultToolkit().getMenuShortcutKeyMask()), "undo");
  imap.put(KeyStroke.getKeyStroke(
    KeyEvent.VK_Y, Toolkit.getDefaultToolkit().getMenuShortcutKeyMask()), "redo");
}

private static class UndoAction extends AbstractAction {
  private final UndoManager undoManager;
  public UndoAction(UndoManager manager) {
    super("undo");
    this.undoManager = manager;
  }

  @Override public void actionPerformed(ActionEvent e) {
    try {
      undoManager.undo();
    } catch (CannotUndoException ex) {
      // ex.printStackTrace();
      Toolkit.getDefaultToolkit().beep();
    }
  }
}
</code></pre>

## 解説
`Document#addUndoableEditListener(UndoManager)`メソッドを使用して`JTextField`に`UndoManager`を追加し、以下のキー入力で`Undo`、`Redo`が実行できるように設定しています。

- `Undo`: <kbd>Ctrl+Z</kbd>
- `Redo`: <kbd>Ctrl+Y</kbd>

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Implementing Undo and Redo (The Java™ Tutorials > Creating a GUI With JFC/Swing > Using Swing Components)](https://docs.oracle.com/javase/tutorial/uiswing/components/generaltext.html#undo)
- [UndoManager (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/undo/UndoManager.html)
- [UndoManagerを使用した文字列選択ペーストの動作を変更する](https://ateraimemo.com/Swing/ReplaceUndoableEdit.html)

<!-- dummy comment line for breaking list -->

## コメント
