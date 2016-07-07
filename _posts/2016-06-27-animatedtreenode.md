---
layout: post
category: swing
folder: AnimatedTreeNode
title: JTreeのTreeNodeにAnimated GIFを表示する
tags: [JTree, ImageIcon, ImageObserver, Animation]
author: aterai
pubdate: 2016-06-27T01:54:58+09:00
description: JTreeのノードに設定したAnimated GIFのImageIconがアニメーションを行えるようにImageObserverを設定します。
comments: true
---
## 概要
`JTree`のノードに設定した`Animated GIF`の`ImageIcon`がアニメーションを行えるように`ImageObserver`を設定します。

{% download https://lh3.googleusercontent.com/-U9WtOD4nOug/V3AE4msfadI/AAAAAAAAOcY/VDwIROM5Ju4gNFBm47FDBJTOtIazp7iyACCo/s800/AnimatedTreeNode.png %}

## サンプルコード
<pre class="prettyprint"><code>TreePath path = new TreePath(s1.getPath());
//Wastefulness: icon.setImageObserver((ImageObserver) tree);
icon.setImageObserver(new ImageObserver() {
  @Override public boolean imageUpdate(Image img, int infoflags, int x, int y, int w, int h) {
    if (!tree.isShowing()) {
      return false;
    }
    Rectangle cellRect = tree.getPathBounds(path);
    if ((infoflags &amp; (FRAMEBITS | ALLBITS)) != 0 &amp;&amp; Objects.nonNull(cellRect)) {
      tree.repaint(cellRect);
    }
    return (infoflags &amp; (ALLBITS | ABORT)) == 0;
  }
});
</code></pre>

## 解説
- `Default`
    - `DefaultMutableTreeNode`の`UserObject`として`Animated GIF`画像から生成した`ImageIcon`を設定し、これを`DefaultTreeCellRenderer#setIcon(...)`でノードに表示
    - このままでは、アニメーションが正常に行われない
- `setImageObserver`
    - 同様に設定した`ImageIcon`に`setImageObserver(ImageObserver)`メソッドで`ImageObserver`を追加し、正常にアニメーションが行えるように画像の更新に合わせて`JTree#repaint(Rectangle)`でノードを再描画
    - 再描画は対象のノードのみになるよう、`JTree.getPathBounds(TreePath)`で取得される領域に制限

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTableのセルにAnimated GIFを表示する](http://ateraimemo.com/Swing/AnimatedIconInTableCell.html)

<!-- dummy comment line for breaking list -->

## コメント
