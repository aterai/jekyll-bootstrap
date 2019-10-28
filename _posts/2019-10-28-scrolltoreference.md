---
layout: post
category: swing
folder: ScrollToReference
title: JEditorPane内のリンク参照位置までスクロールする
tags: [JEditorPane, JScrollPane, HTMLDocument, Html]
author: aterai
pubdate: 2019-10-28T02:33:24+09:00
description: JEditorPaneのHTMLDocument内に配置されたリンクのアンカータグが表示される位置までスクロールします。
image: https://drive.google.com/uc?id=1dnBj5zunBtGVHQ4iD2Kgwqe6IbWCjYSV
comments: true
---
## 概要
`JEditorPane`の`HTMLDocument`内に配置されたリンクのアンカータグが表示される位置までスクロールします。

{% download https://drive.google.com/uc?id=1dnBj5zunBtGVHQ4iD2Kgwqe6IbWCjYSV %}

## サンプルコード
<pre class="prettyprint"><code>HTMLEditorKit htmlEditorKit = new HTMLEditorKit();
JEditorPane editor = new JEditorPane();
editor.setEditable(false);
editor.setEditorKit(htmlEditorKit);
HTMLDocument doc = (HTMLDocument) editor.getDocument();
String tag = "&lt;a name='%s'&gt;%s&lt;/a&gt;";
doc.insertBeforeEnd(element, String.format(tag, ref, ref));

tree.addTreeSelectionListener(e -&gt; {
  Object o = e.getNewLeadSelectionPath().getLastPathComponent();
  if (o instanceof DefaultMutableTreeNode) {
    DefaultMutableTreeNode node = (DefaultMutableTreeNode) o;
    String ref = Objects.toString(node.getUserObject());
    editor.scrollToReference(ref);
  }
});
</code></pre>

## 解説
- `JTree`のノードを選択すると、そのノードの`UserObject`と一致する`<a>`アンカータグの`name`属性をもつリンクをまで`JEditorPane#scrollToReference(ref)`メソッドを使用してビューをスクロールする
    - `id`属性や`href`属性などを指定しても`JEditorPane#scrollToReference(ref)`メソッドでは効果がない
- `bottom`ボタンをクリックすると、ドキュメントの末尾に記述した`<p id='bottom'>`タグが表示される位置までスクロール
    - `JEditorPane#scrollToReference(ref)`メソッドの実装を参考にして、`HTMLElement#getElement(id)`メソッドで`id`が`bottom`の`Element`を検索してその位置まで`JEditorPane#scrollRectToVisible(...)`メソッドでスクールするメソッドを作成

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>private static void scrollToId(JEditorPane editor, String id) {
  Document d = editor.getDocument();
  if (d instanceof HTMLDocument) {
    HTMLDocument doc = (HTMLDocument) d;
    Element element = doc.getElement(id);
    try {
      int pos = element.getStartOffset();
      Rectangle r = editor.modelToView(pos);
      if (r != null) {
        Rectangle vis = editor.getVisibleRect();
        r.height = vis.height;
        editor.scrollRectToVisible(r);
        editor.setCaretPosition(pos);
      }
    } catch (BadLocationException ex) {
      UIManager.getLookAndFeel().provideErrorFeedback(editor);
    }
  }
}
</code></pre>

## 参考リンク
- [JEditorPane (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JEditorPane.html#scrollToReference-java.lang.String-)
- [JScrollPane内にあるJTableなどで追加した行が可視化されるようにスクロールする](https://ateraimemo.com/Swing/ScrollRectToVisible.html)
- [JTreeとCardLayoutでサイドメニューを作成する](https://ateraimemo.com/Swing/VerticalNavigationMenu.html)

<!-- dummy comment line for breaking list -->

## コメント
