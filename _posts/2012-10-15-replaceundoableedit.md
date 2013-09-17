---
layout: post
title: UndoManagerを使用した文字列選択ペーストの動作を変更する
category: swing
folder: ReplaceUndoableEdit
tags: [JTextField, UndoManager, PlainDocument, JTextComponent]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-10-15

## UndoManagerを使用した文字列選択ペーストの動作を変更する
`JTextField`などに`UndoManager`を設定し、文字列を選択してペーストした後の`Undo`の動作を変更します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh5.googleusercontent.com/-GEc9R-QZvos/UKt2czK61tI/AAAAAAAABXk/vqH8TKxkqCM/s800/ReplaceUndoableEdit.png)

### サンプルコード
<pre class="prettyprint"><code>Document doc = new PlainDocument() {
  @Override public void replace(
      int offset, int length, String text, AttributeSet attrs)
        throws BadLocationException {
    if(length!=0) { //replace
      undoManager.undoableEditHappened(
        new UndoableEditEvent(this, new ReplaceUndoableEdit(offset, length, text)));
      replaceIgnoringUndo(offset, length, text, attrs);
    }else{ //insert
      super.replace(offset, length, text, attrs);
    }
  }
  private void replaceIgnoringUndo(
      int offset, int length, String text, AttributeSet attrs)
        throws BadLocationException {
    removeUndoableEditListener(undoManager);
    super.replace(offset, length, text, attrs);
    addUndoableEditListener(undoManager);
  }
  class ReplaceUndoableEdit extends AbstractUndoableEdit {
    private final String oldValue;
    private final String newValue;
    private int offset;
    public ReplaceUndoableEdit(int offset, int length, String newValue) {
      String txt;
      try{
        txt = getText(offset, length);
      }catch(BadLocationException e) {
        txt = null;
      }
      this.oldValue = txt;
      this.newValue = newValue;
      this.offset = offset;
    }
    @Override public void undo() throws CannotUndoException {
      try{
        replaceIgnoringUndo(offset, newValue.length(), oldValue, null);
      }catch(BadLocationException ex) {
        throw new CannotUndoException();
      }
    }
    @Override public void redo() throws CannotRedoException {
      try{
        replaceIgnoringUndo(offset, oldValue.length(), newValue, null);
      }catch(BadLocationException ex) {
        throw new CannotUndoException();
      }
    }
    @Override public boolean canUndo() {
      return true;
    }
    @Override public boolean canRedo() {
      return true;
    }
  }
};
</code></pre>

### 解説
- 上: デフォルト
    - `JTextComponent#setText(String)`や、文字列を選択してペーストした場合、`Document#replace(...)`で実行される`Document#remove(...)`と`Document#insertString(...)`が別々に`UndoManager`に登録される仕様?なので、二回`Undo`しないとペースト前の状態に戻らない
- 下
    - `Document#replace(...)`をオーバーライドし、直接`UndoManager#undoableEditHappened(...)`を使って取り消し可能な編集を登録
    - 実際の置換は、`removeUndoableEditListener(...)`で`UndoManager`を一時的に削除した後に行う(直後に`addUndoableEditListener()`で再登録)
    - 登録する`UndoableEdit`での`Undo`, `Redo`時の置換も`UndoManager`を一時的に削除して行う
    - メモ: このサンプルでは選択状態を復元していない

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Undo manager : Undo Redo « Swing JFC « Java](http://www.java2s.com/Code/Java/Swing-JFC/Undomanager.htm)
- [Compound Undo Manager ≪ Java Tips Weblog](http://tips4java.wordpress.com/2008/10/27/compound-undo-manager/)
- [Merging UndoableEdits in one to be undone all together in JEditorPane.](http://java-sl.com/tip_merge_undo_edits.html)
- [java - Undo in JTextField and setText - Stack Overflow](http://stackoverflow.com/questions/12844520/undo-in-jtextfield-and-settext)
- [Java Swing「UndoManager」メモ(Hishidama's Swing-UndoManager Memo)](http://www.ne.jp/asahi/hishidama/home/tech/java/swing/UndoManager.html)
- [Java Swingで複数のJTextFieldに対してUndo、Redoを行う（その2）－解決編 kyoはパソコンMaster or Slave?/ウェブリブログ](http://kyopc.at.webry.info/201007/article_1.html)
- [バカが征く on Rails 2010年03月16日()](http://bakagaiku.hsbt.org/entry/20100316)
- [UndoManagerでJTextFieldのUndo、Redoを行う](http://terai.xrea.jp/Swing/UndoManager.html)

<!-- dummy comment line for breaking list -->

### コメント
