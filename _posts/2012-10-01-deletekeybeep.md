---
layout: post
title: JTextFieldでのBeep音の設定を変更する
category: swing
folder: DeleteKeyBeep
tags: [JTextField, Beep, ActionMap, DocumentFilter]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-10-01

## JTextFieldでのBeep音の設定を変更する
`JTextField`などで、<kbd>Delete</kbd>、<kbd>Back Space</kbd>キーを押した時に鳴らす`Beep`音の設定を変更します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/-zIUmkF2C9FA/UGkqdcWDLVI/AAAAAAAABTk/F4nun0GDLZc/s800/DeleteKeyBeep.png)

### サンプルコード
<pre class="prettyprint"><code>String key = "delete-previous";
final Action deletePreviousAction = am.get(key);
am.put(key, new TextAction(DefaultEditorKit.deletePrevCharAction) {
  //@see javax/swing/text/DefaultEditorKit.java DeletePrevCharAction
  @Override public void actionPerformed(ActionEvent e) {
    JTextComponent target = getTextComponent(e);
    if(target != null &amp;&amp; target.isEditable()) {
      Caret caret = target.getCaret();
      int dot = caret.getDot();
      int mark = caret.getMark();
      if(dot==0 &amp;&amp; mark==0) {
        return;
      }
    }
    deletePreviousAction.actionPerformed(e);
  }
});
key = "delete-next";
final Action deleteNextAction = am.get(key);
am.put(key, new TextAction(DefaultEditorKit.deleteNextCharAction) {
  //@see javax/swing/text/DefaultEditorKit.java DeleteNextCharAction
  @Override public void actionPerformed(ActionEvent e) {
    JTextComponent target = getTextComponent(e);
    if(target != null &amp;&amp; target.isEditable()) {
      Document doc = target.getDocument();
      Caret caret = target.getCaret();
      int dot = caret.getDot();
      int mark = caret.getMark();
      if(dot==mark &amp;&amp; doc.getLength()==dot) {
        return;
      }
    }
    deleteNextAction.actionPerformed(e);
  }
});
</code></pre>

### 解説
上記のサンプルでは、以下の二点を変更して、`Beep`音の設定を変更しています。

- `TextAction(DefaultEditorKit.deleteNextCharAction)#actionPerformed(ActionEvent)`などをオーバーライドして、<kbd>Delete</kbd>キーや<kbd>Back Space</kbd>キーで文字の削除がなくても、`Beep`音を鳴らさないように変更したアクションを`ActionMap`に設定
- 5文字以上入力できないように制限し、超える場合は`Beep`音を鳴らす`DocumentFilter`を作成して、`AbstractDocument#setDocumentFilter(DocumentFilter)`で設定

<!-- dummy comment line for breaking list -->

### 参考リンク
- [DocumentSizeFilter.java](http://docs.oracle.com/javase/tutorial/displayCode.html?code=http://docs.oracle.com/javase/tutorial/uiswing/examples/components/TextComponentDemoProject/src/components/DocumentSizeFilter.java)
    - via: [Text Component Features (The Java™ Tutorials > Creating a GUI With JFC/Swing > Using Swing Components)](http://docs.oracle.com/javase/tutorial/uiswing/components/generaltext.html)

<!-- dummy comment line for breaking list -->

### コメント