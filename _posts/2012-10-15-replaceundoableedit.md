---
layout: post
category: swing
folder: ReplaceUndoableEdit
title: UndoManagerを使用した文字列選択ペーストの動作を変更する
tags: [JTextField, UndoManager, PlainDocument, JTextComponent, CompoundEdit, DocumentFilter, UndoableEdit]
author: aterai
pubdate: 2012-10-15T14:31:20+09:00
description: JTextFieldなどにUndoManagerを設定し、文字列を選択してペーストした後のUndoの動作を変更します。
image: https://lh5.googleusercontent.com/-GEc9R-QZvos/UKt2czK61tI/AAAAAAAABXk/vqH8TKxkqCM/s800/ReplaceUndoableEdit.png
hreflang:
    href: http://java-swing-tips.blogspot.com/2014/06/merge-replaceeditremove-and.html
    lang: en
comments: true
---
## 概要
`JTextField`などに`UndoManager`を設定し、文字列を選択してペーストした後の`Undo`の動作を変更します。

{% download https://lh5.googleusercontent.com/-GEc9R-QZvos/UKt2czK61tI/AAAAAAAABXk/vqH8TKxkqCM/s800/ReplaceUndoableEdit.png %}

## サンプルコード
<pre class="prettyprint"><code>class CustomUndoPlainDocument extends PlainDocument {
  private CompoundEdit compoundEdit;
  @Override protected void fireUndoableEditUpdate(UndoableEditEvent e) {
    if (compoundEdit == null) {
      super.fireUndoableEditUpdate(e);
    } else {
      compoundEdit.addEdit(e.getEdit());
    }
  }
  @Override public void replace(
      int offset, int length, String text, AttributeSet attrs)
      throws BadLocationException {
    if (length == 0) { //insert
      System.out.println("insert");
      super.replace(offset, length, text, attrs);
    } else { //replace
      System.out.println("replace");
      compoundEdit = new CompoundEdit();
      super.fireUndoableEditUpdate(new UndoableEditEvent(this, compoundEdit));
      super.replace(offset, length, text, attrs);
      compoundEdit.end();
      compoundEdit = null;
    }
  }
}
</code></pre>

## 解説
- 上: `Default`
    - `JTextComponent#setText(String)`や、文字列を選択してペーストした場合、`Document#replace(...)`で実行される`Document#remove(...)`と`Document#insertString(...)`が別々に`UndoManager`に登録される仕様なので、二回`Undo`しないとペースト前の状態まで戻らない
- 中: `Document#replace()+AbstractDocument#fireUndoableEditUpdate()`
    - `Document#replace(...)`をオーバーライドし、~~直接`UndoManager#undoableEditHappened(...)`を使って取り消し可能な編集を登録~~ `setText(...)`での文字列の削除と追加を`CompoundEdit`にまとめる
    - ~~実際の置換は、`removeUndoableEditListener(...)`で`UndoManager`を一時的に削除した後に行う(直後に`addUndoableEditListener()`で再登録)~~
    - ~~登録する`UndoableEdit`での`Undo`, `Redo`時の置換も`UndoManager`を一時的に削除して行う~~
    - メモ: このサンプルでは選択状態を復元していない
- 下: `DocumentFilter#replace()+UndoableEditListener#undoableEditHappened()`
    - `DocumentFilter#replace(...)`をオーバーライドし、文字列の置換で発生する削除と追加の`UndoableEdit`を別途用意した`CompoundEdit`にまとめてから`UndoManager#addEdit(...)`で追加

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>class DocumentFilterUndoManager extends UndoManager {
  private CompoundEdit compoundEdit;
  private final transient DocumentFilter undoFilter = new DocumentFilter() {
    @Override public void replace(
        DocumentFilter.FilterBypass fb, int offset, int length,
        String text, AttributeSet attrs) throws BadLocationException {
      if (length == 0) {
        fb.insertString(offset, text, attrs);
      } else {
        compoundEdit = new CompoundEdit();
        fb.replace(offset, length, text, attrs);
        compoundEdit.end();
        addEdit(compoundEdit);
        compoundEdit = null;
      }
    }
  };
  public DocumentFilter getDocumentFilter() {
    return undoFilter;
  }
  @Override public void undoableEditHappened(UndoableEditEvent e) {
    Optional.ofNullable(compoundEdit).orElse(this).addEdit(e.getEdit());
  }
}
</code></pre>

## 参考リンク
- [Undo two or more actions at once | Oracle Community](https://community.oracle.com/thread/1509622)
- [Undo manager : Undo Redo « Swing JFC « Java](http://www.java2s.com/Code/Java/Swing-JFC/Undomanager.htm)
- [Compound Undo Manager ≪ Java Tips Weblog](https://tips4java.wordpress.com/2008/10/27/compound-undo-manager/)
- [Merging UndoableEdits in one to be undone all together in JEditorPane.](http://java-sl.com/tip_merge_undo_edits.html)
- [java - JTextArea setText() & UndoManager - Stack Overflow](https://stackoverflow.com/questions/24433089/jtextarea-settext-undomanager)
- [java - Undo in JTextField and setText - Stack Overflow](https://stackoverflow.com/questions/12844520/undo-in-jtextfield-and-settext)
- [Java Swing「UndoManager」メモ(Hishidama's Swing-UndoManager Memo)](http://www.ne.jp/asahi/hishidama/home/tech/java/swing/UndoManager.html)
- [Java Swingで複数のJTextFieldに対してUndo、Redoを行う（その2）－解決編 kyoはパソコンMaster or Slave?/ウェブリブログ](http://kyopc.at.webry.info/201007/article_1.html)
- [バカが征く on Rails 2010年03月16日()](http://bakagaiku.hsbt.org/entry/20100316)
- [UndoManagerでJTextFieldのUndo、Redoを行う](https://ateraimemo.com/Swing/UndoManager.html)

<!-- dummy comment line for breaking list -->

## コメント
