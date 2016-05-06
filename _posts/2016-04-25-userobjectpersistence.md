---
layout: post
category: swing
folder: UserObjectPersistence
title: JTreeのノードに追加したJCheckBoxのチェック状態の保存と復元
tags: [JTree, JCheckBox, XMLEncoder, XMLDecoder]
author: aterai
pubdate: 2016-04-25T00:07:44+09:00
description: JTreeのノードに追加したJCheckBoxのチェック状態など保持する`UserObject`を永続化可能になるよう設定し、その保存と復元を行います。
comments: true
---
## 概要
`JTree`のノードに追加した`JCheckBox`のチェック状態など保持する`UserObject`を永続化可能になるよう設定し、その保存と復元を行います。

{% download https://lh3.googleusercontent.com/-Foeg7fF4Uj4/VxzbvHpNTUI/AAAAAAAAOTY/LnDkJRi6CtQXJcQAGJ2boc27LJrY_lT-QCCo/s800/UserObjectPersistence.png %}

## サンプルコード
<pre class="prettyprint"><code>try {
  File file = new File("output.xml");
  try (XMLEncoder xe = new XMLEncoder(
      new BufferedOutputStream(new FileOutputStream(file)))) {
    xe.setPersistenceDelegate(
        CheckBoxNode.class,
        new DefaultPersistenceDelegate(new String[] {"label", "status"}));
    xe.writeObject(tree.getModel());
  }
} catch (IOException ex) {
  ex.printStackTrace();
}
</code></pre>

## 解説
上記のサンプルでは、[JTreeのすべてのノードにJCheckBoxを追加する](http://ateraimemo.com/Swing/CheckBoxNodeEditor.html)などで使用しているチェックボックス付き`JTree`を、そのチェック状態も含めて永続化を行っています。

- `JTree`の`DefaultTreeModel`や`DefaultMutableTreeNode`は、デフォルトで`XMLEncoder`に対応
- `UserObject`として名前とチェック状態を保持する`CheckBoxNode`クラスは`XMLEncoder`に未対応なので、`DefaultPersistenceDelegate`で書き出し保存するプロパティを指定
- チェック状態を表す`Status`は`Enum`で`XMLEncoder`はデフォルトで対応
    - `public`なクラスにしておく必要がある
- 親ノードなどのチェック状態を更新する`TreeModelListener`は、永続化していないので、`XMLDecoder`で`DefaultTreeModel`を復元後に再度`addTreeModelListener`で設定し直す必要がある

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTableのSortKeyを永続化し、ソート状態の保存と復元を行う](http://ateraimemo.com/Swing/SortKeyPersistence.html)
- [JTreeのすべてのノードにJCheckBoxを追加する](http://ateraimemo.com/Swing/CheckBoxNodeEditor.html)
- [JTreeの展開状態を記憶・復元する](http://ateraimemo.com/Swing/ExpandedDescendants.html)

<!-- dummy comment line for breaking list -->

## コメント