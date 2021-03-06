---
layout: post
category: swing
folder: VerticalNavigationMenu
title: JTreeとCardLayoutでサイドメニューを作成する
tags: [JTree, CardLayout, TreeSelectionListener]
author: aterai
pubdate: 2017-10-02T15:53:07+09:00
description: JTreeのスタイルを変更してサイドメニュー風のコンポーネントを作成し、ノード選択に応じてCardLayoutでのパネル切り替えを実行します。
image: https://drive.google.com/uc?id=1HtdjEFvmcBet6Qv2s2zHMZWTgzkb2rcqqQ
comments: true
---
## 概要
`JTree`のスタイルを変更してサイドメニュー風のコンポーネントを作成し、ノード選択に応じて`CardLayout`でのパネル切り替えを実行します。

{% download https://drive.google.com/uc?id=1HtdjEFvmcBet6Qv2s2zHMZWTgzkb2rcqqQ %}

## サンプルコード
<pre class="prettyprint"><code>TreeModel model = makeModel();
CardLayout cardLayout = new CardLayout();
JPanel p = new JPanel(cardLayout);
DefaultMutableTreeNode root = (DefaultMutableTreeNode) model.getRoot();
Enumeration en = root.postorderEnumeration();
while (en.hasMoreElements()) {
  DefaultMutableTreeNode node = (DefaultMutableTreeNode) en.nextElement();
  String title = Objects.toString(node.getUserObject());
  p.add(new JLabel(title), title);
}

JTree tree = new RowSelectionTree();
tree.setModel(model);
tree.getSelectionModel().setSelectionMode(TreeSelectionModel.SINGLE_TREE_SELECTION);
tree.addTreeSelectionListener(e -&gt; {
  // https://ateraimemo.com/Swing/CardLayoutTabbedPane.html
  Object o = tree.getLastSelectedPathComponent();
  if (o instanceof DefaultMutableTreeNode) {
    DefaultMutableTreeNode node = (DefaultMutableTreeNode) o;
    String title = Objects.toString(node.getUserObject());
    cardLayout.show(p, title);
  }
});
</code></pre>

## 解説
- `JTree`のスタイルをサイドメニュー風に変更
    - ルートノードを非表示: [JTreeのルートノードを非表示に設定する](https://ateraimemo.com/Swing/TreeRootVisible.html)
    - ノード選択をシングルセレクションモードに変更: [JTreeの選択モードを切り替える](https://ateraimemo.com/Swing/TreeSelection.html)
    - ノードアイコンを非表示: [JTreeのOpenIcon、ClosedIcon、LeafIconを変更](https://ateraimemo.com/Swing/TreeLeafIcon.html)
    - 展開、折畳みアイコンを非表示: [JTreeの展開、折畳みアイコンを非表示にする](https://ateraimemo.com/Swing/TreeExpandedIcon.html)
    - 初期状態でノードを全展開: [JTreeのノードを展開・折り畳み](https://ateraimemo.com/Swing/ExpandAllNodes.html)
    - ノードを選択可能で折り畳みを不可に設定: [JTreeのノードを折り畳み不可に設定する](https://ateraimemo.com/Swing/TreeNodeCollapseVeto.html)
    - 行全体を選択背景色で描画: [JTreeを行クリックで選択し、行全体を選択状態の背景色で描画](https://ateraimemo.com/Swing/TreeRowSelection.html)
- ノード選択を`TreeSelectionListener`で取得し対応するタイトルのパネルを`CardLayout`で切り替え
    - [JTree#addTreeSelectionListener(...)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTree.html#addTreeSelectionListener-javax.swing.event.TreeSelectionListener-)メソッドを使用してノード選択イベントを取得
    - ノードタイトルをキーに`CardLayout`で右パネルの切り替えを実行

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTree#addTreeSelectionListener(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTree.html#addTreeSelectionListener-javax.swing.event.TreeSelectionListener-)
- [CardLayoutを使ってJTabbedPane風のコンポーネントを作成](https://ateraimemo.com/Swing/CardLayoutTabbedPane.html)

<!-- dummy comment line for breaking list -->

## コメント
