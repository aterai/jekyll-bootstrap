---
layout: post
category: swing
folder: DeleteKeyBeep
title: JTextFieldでのBeep音の設定を変更する
tags: [JTextField, Beep, ActionMap, DocumentFilter]
author: aterai
pubdate: 2012-10-01T14:42:41+09:00
description: JTextFieldなどで、KBD{Delete}、KBD{Back Space}キーを押した時に鳴らすBeep音の設定を変更します。
image: https://lh6.googleusercontent.com/-zIUmkF2C9FA/UGkqdcWDLVI/AAAAAAAABTk/F4nun0GDLZc/s800/DeleteKeyBeep.png
comments: true
---
## 概要
`JTextField`などで、<kbd>Delete</kbd>、<kbd>Back Space</kbd>キーを押した時に鳴らす`Beep`音の設定を変更します。

{% download https://lh6.googleusercontent.com/-zIUmkF2C9FA/UGkqdcWDLVI/AAAAAAAABTk/F4nun0GDLZc/s800/DeleteKeyBeep.png %}

## サンプルコード
<pre class="prettyprint"><code>String key = DefaultEditorKit.deletePrevCharAction; //"delete-previous";
final Action deletePreviousAction = am.get(key);
am.put(key, new TextAction(key) {
  //@see javax/swing/text/DefaultEditorKit.java DeletePrevCharAction
  @Override public void actionPerformed(ActionEvent e) {
    JTextComponent target = getTextComponent(e);
    if (target != null &amp;&amp; target.isEditable()) {
      Caret caret = target.getCaret();
      int dot = caret.getDot();
      int mark = caret.getMark();
      if (dot == 0 &amp;&amp; mark == 0) {
        return;
      }
    }
    deletePreviousAction.actionPerformed(e);
  }
});
key = DefaultEditorKit.deleteNextCharAction; //"delete-next";
final Action deleteNextAction = am.get(key);
am.put(key, new TextAction(key) {
  //@see javax/swing/text/DefaultEditorKit.java DeleteNextCharAction
  @Override public void actionPerformed(ActionEvent e) {
    JTextComponent target = getTextComponent(e);
    if (target != null &amp;&amp; target.isEditable()) {
      Document doc = target.getDocument();
      Caret caret = target.getCaret();
      int dot = caret.getDot();
      int mark = caret.getMark();
      if (dot == mark &amp;&amp; doc.getLength() == dot) {
        return;
      }
    }
    deleteNextAction.actionPerformed(e);
  }
});
</code></pre>

## 解説
上記のサンプルでは、以下の`2`点を変更して、`Beep`音の設定を変更しています。

- `TextAction(DefaultEditorKit.deleteNextCharAction)#actionPerformed(ActionEvent)`メソッドなどをオーバーライドして、<kbd>Delete</kbd>キーや<kbd>Back Space</kbd>キーで文字の削除がなくても、`Beep`音を鳴らさないように変更したアクションを`ActionMap`に設定
- `5`文字以上入力できないように制限し、超える場合は`Beep`音を鳴らす`DocumentFilter`を作成して、`AbstractDocument#setDocumentFilter(DocumentFilter)`で設定

<!-- dummy comment line for breaking list -->

## 参考リンク
- [DocumentSizeFilter.java](https://docs.oracle.com/javase/tutorial/displayCode.html?code=https://docs.oracle.com/javase/tutorial/uiswing/examples/components/TextComponentDemoProject/src/components/DocumentSizeFilter.java)
    - via: [Text Component Features (The Java™ Tutorials > Creating a GUI With JFC/Swing > Using Swing Components)](https://docs.oracle.com/javase/tutorial/uiswing/components/generaltext.html)

<!-- dummy comment line for breaking list -->

## コメント
