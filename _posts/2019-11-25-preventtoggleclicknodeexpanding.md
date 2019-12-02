---
layout: post
category: swing
folder: PreventToggleClickNodeExpanding
title: JTreeで特定のノードをマウスクリックした場合のみ展開不可に設定する
tags: [JTree]
author: aterai
pubdate: 2019-11-25T12:42:39+09:00
description: JTreeで特定の親ノードをマウスクリックした場合のみ展開・折り畳みを不可に設定します。
image: https://drive.google.com/uc?id=1cFSEIvHIrn8nmolJt9cWlyVen4iEpBjV
comments: true
---
## 概要
`JTree`で特定の親ノードをマウスクリックした場合のみ展開・折り畳みを不可に設定します。

{% download https://drive.google.com/uc?id=1cFSEIvHIrn8nmolJt9cWlyVen4iEpBjV %}

## サンプルコード
<pre class="prettyprint"><code>JTree tree1 = new JTree(treeModel);
tree1.addTreeWillExpandListener(new FileExpandVetoListener());

JTree tree2 = new JTree(treeModel);
tree2.setUI(new MetalTreeUI() {
  @Override protected boolean isToggleEvent(MouseEvent e) {
    File file = getFileFromTreePath(tree.getSelectionPath());
    return file == null &amp;&amp; super.isToggleEvent(e);
  }
});
</code></pre>

## 解説
上記のサンプルでは起動ディレクトリ以下のファイルを`JTree`で一覧表示し、ファイル名が`MainPanel.java`のノードのみマウスクリックで展開不可になるよう設定しています。

- 左: `TreeWillExpandListener`
    - [JTreeで展開不可のノードを設定する](https://ateraimemo.com/Swing/PreventNodeExpanding.html)
    - `TreeWillExpandListener`を設定して特定のノードの展開をすべて不可に設定
    - キー入力、ノードのマウスクリック、展開・折り畳みアイコンのマウスクリック、ポップアップメニューからの展開などのすべてが不可になる
- 右: `override MetalTreeUI#isToggleEvent(...)`
    - `MetalTreeUI#isToggleEvent(...)`メソッドをオーバーライドして特定ノードのマウスクリックのみ展開を不可に設定
    - キー入力、展開・折り畳みアイコンのマウスクリックであれば、展開可能
    - すべてのノードをキー入力、展開・折り畳みアイコンのマウスクリックで展開可能、ノードのマウスクリックのみ展開を不可にする場合は`tree.setToggleClickCount(0);`が使用可能

<!-- dummy comment line for breaking list -->

## 参考リンク
    - [JTreeで展開不可のノードを設定する](https://ateraimemo.com/Swing/PreventNodeExpanding.html)
- [JTreeのノードを折り畳み不可に設定する](https://ateraimemo.com/Swing/TreeNodeCollapseVeto.html)

<!-- dummy comment line for breaking list -->

## コメント
