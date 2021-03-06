---
layout: post
category: swing
folder: DnDBetweenTrees
title: JTree間でのドラッグ＆ドロップによるノードの移動
tags: [JTree, DragAndDrop, TransferHandler]
author: aterai
pubdate: 2016-02-22T00:58:53+09:00
description: JTree間でのドラッグ＆ドロップによるノードの移動を行います。
image: https://lh3.googleusercontent.com/-orv222AWr0E/VsnVITv64uI/AAAAAAAAOPE/vGmbPDCu4nY/s800-Ic42/DnDBetweenTrees.png
comments: true
---
## 概要
`JTree`間でのドラッグ＆ドロップによるノードの移動を行います。

{% download https://lh3.googleusercontent.com/-orv222AWr0E/VsnVITv64uI/AAAAAAAAOPE/vGmbPDCu4nY/s800-Ic42/DnDBetweenTrees.png %}

## サンプルコード
<pre class="prettyprint"><code>class TreeTransferHandler extends TransferHandler {
  private static final DataFlavor FLAVOR = new DataFlavor(
      DefaultMutableTreeNode[].class,
      "Array of DefaultMutableTreeNode");
  private JTree source;

  @Override protected Transferable createTransferable(JComponent c) {
    source = (JTree) c;
    TreePath[] paths = source.getSelectionPaths();
    DefaultMutableTreeNode[] nodes = new DefaultMutableTreeNode[paths.length];
    for (int i = 0; i &lt; paths.length; i++) {
      nodes[i] = (DefaultMutableTreeNode) paths[i].getLastPathComponent();
    }
    return new Transferable() {
      @Override public DataFlavor[] getTransferDataFlavors() {
        return new DataFlavor[] {FLAVOR};
      }
      @Override public boolean isDataFlavorSupported(DataFlavor flavor) {
        return Objects.equals(FLAVOR, flavor);
      }
      @Override public Object getTransferData(DataFlavor flavor)
            throws UnsupportedFlavorException, IOException {
        if (isDataFlavorSupported(flavor)) {
          return nodes;
        } else {
          throw new UnsupportedFlavorException(flavor);
        }
      }
    };
  }

  @Override public int getSourceActions(JComponent c) {
    return MOVE;
  }

  @Override public boolean canImport(TransferHandler.TransferSupport support) {
    if (!support.isDrop()) {
      return false;
    }
    if (!support.isDataFlavorSupported(FLAVOR)) {
      return false;
    }
    JTree tree = (JTree) support.getComponent();
    return !tree.equals(source);
  }

  @Override public boolean importData(TransferHandler.TransferSupport support) {
    DefaultMutableTreeNode[] nodes = null;
    try {
      Transferable t = support.getTransferable();
      nodes = (DefaultMutableTreeNode[]) t.getTransferData(FLAVOR);
    } catch (UnsupportedFlavorException | IOException ex) {
      ex.printStackTrace();
    }
    TransferHandler.DropLocation tdl = support.getDropLocation();
    if (tdl instanceof JTree.DropLocation) {
      JTree.DropLocation dl = (JTree.DropLocation) tdl;
      int childIndex = dl.getChildIndex();
      TreePath dest = dl.getPath();
      DefaultMutableTreeNode parent =
        (DefaultMutableTreeNode) dest.getLastPathComponent();
      JTree tree = (JTree) support.getComponent();
      DefaultTreeModel model = (DefaultTreeModel) tree.getModel();
      int idx = childIndex &lt; 0 ? parent.getChildCount() : childIndex;
      //DefaultTreeModel sm = (DefaultTreeModel) source.getModel();
      for (DefaultMutableTreeNode node : nodes) {
        //sm.removeNodeFromParent(node);
        //model.insertNodeInto(node, parent, idx++);
        DefaultMutableTreeNode clone = new DefaultMutableTreeNode(node.getUserObject());
        model.insertNodeInto(deepCopyTreeNode(node, clone), parent, idx++);
      }
      return true;
    }
    return false;
  }
  private static DefaultMutableTreeNode deepCopyTreeNode(
      DefaultMutableTreeNode src, DefaultMutableTreeNode tgt) {
    for (int i = 0; i &lt; src.getChildCount(); i++) {
      DefaultMutableTreeNode node  = (DefaultMutableTreeNode) src.getChildAt(i);
      DefaultMutableTreeNode clone = new DefaultMutableTreeNode(node.getUserObject());
      tgt.add(clone);
      if (!node.isLeaf()) {
        deepCopyTreeNode(node, clone);
      }
    }
    return tgt;
  }
  @Override protected void exportDone(
      JComponent source, Transferable data, int action) {
    if (action == TransferHandler.MOVE) {
      JTree tree = (JTree) source;
      DefaultTreeModel model = (DefaultTreeModel) tree.getModel();
      for (TreePath path : tree.getSelectionPaths()) {
        model.removeNodeFromParent((MutableTreeNode) path.getLastPathComponent());
      }
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JTree`間でのノード移動を可能にする`TransferHandler`を作成して、`JTree#setTransferHandler(...)`で設定しています。

`TransferHandler#importData(...)`メソッド内で、ドラッグして移動する`DefaultMutableTreeNode`をドラッグ元の`DefaultTreeModel`から削除せずに、`DefaultTreeModel#insertNodeInto(...)`メソッドでドロップ先の`JTree`の`DefaultTreeModel`に挿入すると、ノードの親子関係がおかしくなって、ドラッグ元の`JTree`から`DefaultTreeModel#removeNodeFromParent(...)`メソッドでノードを削除できなくなります(`DefaultTreeModel.reload()`ですべて再評価すると正常に表示されるが、ノードがすべて折り畳まれてしまう)。これを避けるために、移動する`DefaultMutableTreeNode`のクローン(親ノードは未設定)を作成してドロップ元に追加し、ドラッグ元からの削除は`TransferHandler#exportDone(...)`で実行するようにしています。

- 制限:
    - 同一`JTree`内でのノード入れ替えには未対応
    - `TreeSelectionModel.SINGLE_TREE_SELECTION`で選択、移動できるのは`1`ノードのみに制限
    - `TransferHandler.MOVE`で移動のみに対応
    - ルートノードは、`JTree#setRootVisible(false)`で非表示にして移動禁止

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTreeのノードをドラッグ＆ドロップ](https://ateraimemo.com/Swing/DnDTree.html)

<!-- dummy comment line for breaking list -->

## コメント
