---
layout: post
category: swing
folder: UndoManager
title: UndoManagerでJTextFieldのUndo、Redoを行う
tags: [JTextField, JTextComponent, UndoManager, ActionMap, Document]
author: aterai
pubdate: 2009-06-15T13:35:15+09:00
description: JTextFieldのドキュメントにUndoManagerを追加して、Undo、Redoを行います。
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
  imap.put(KeyStroke.getKeyStroke(KeyEvent.VK_Z, InputEvent.CTRL_DOWN_MASK), "undo");
  imap.put(KeyStroke.getKeyStroke(KeyEvent.VK_Y, InputEvent.CTRL_DOWN_MASK), "redo");
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
    } catch (CannotUndoException cue) {
      //cue.printStackTrace();
      Toolkit.getDefaultToolkit().beep();
    }
  }
}
</code></pre>

## 解説
`Document#addUndoableEditListener(UndoManager)`メソッドを使って、`JTextField`で`Undo`、`Redo`が以下のキー入力で実行できるように設定しています。

- `Undo` : <kbd>Ctrl+Z</kbd>
- `Redo` : <kbd>Ctrl+Y</kbd>

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Implementing Undo and Redo (Text Component Features The Java™ Tutorialsg)](http://docs.oracle.com/javase/tutorial/uiswing/components/generaltext.html#undo)
- [UndoManagerを使用した文字列選択ペーストの動作を変更する](http://ateraimemo.com/Swing/ReplaceUndoableEdit.html)

<!-- dummy comment line for breaking list -->

## コメント
