---
layout: post
category: swing
folder: DirectoryTree
title: FileSystemViewを使ってディレクトリ構造をJTreeに表示する
tags: [JTree, File, FileSystemView, SwingWorker]
author: aterai
pubdate: 2011-07-04T16:26:25+09:00
description: FileSystemViewを使ってディレクトリ構造をJTree上に表示します。
image: https://lh3.googleusercontent.com/-FkX-8X4KxDo/ThFoeY8M64I/AAAAAAAAA-Y/Ry_RA9yVCxc/s800/DirectoryTree.png
comments: true
---
## 概要
`FileSystemView`を使ってディレクトリ構造を`JTree`上に表示します。主に[java - File Browser GUI - Stack Overflow](https://stackoverflow.com/questions/6182110/file-browser-gui)を参考にしています。

{% download https://lh3.googleusercontent.com/-FkX-8X4KxDo/ThFoeY8M64I/AAAAAAAAA-Y/Ry_RA9yVCxc/s800/DirectoryTree.png %}

## サンプルコード
<pre class="prettyprint"><code>class FolderSelectionListener implements TreeSelectionListener {
  private final FileSystemView fileSystemView;
  public FolderSelectionListener(FileSystemView fileSystemView) {
    this.fileSystemView = fileSystemView;
  }
  @Override public void valueChanged(TreeSelectionEvent e) {
    final JTree tree = (JTree) e.getSource();
    final DefaultMutableTreeNode node =
      (DefaultMutableTreeNode) e.getPath().getLastPathComponent();
    final DefaultTreeModel model = (DefaultTreeModel) tree.getModel();
    //final TreePath path = e.getPath();

    if (!node.isLeaf()) return;
    final File parent = (File) node.getUserObject();
    if (!parent.isDirectory()) return;

    SwingWorker&lt;String, File&gt; worker = new SwingWorker&lt;String, File&gt;() {
      @Override public String doInBackground() {
        File[] children = fileSystemView.getFiles(parent, true);
        for (File child: children) {
          if (child.isDirectory()) {
            publish(child);
          }
        }
        return "done";
      }
      @Override protected void process(List&lt;File&gt; chunks) {
        for (File file: chunks) {
          node.add(new DefaultMutableTreeNode(file));
        }
        model.nodeStructureChanged(node);
        //tree.expandPath(path);
      }
    };
    worker.execute();
  }
}
</code></pre>

## 解説
このサンプルでは、[java - File Browser GUI - Stack Overflow](https://stackoverflow.com/questions/6182110/file-browser-gui)のディレクトリ表示部分を抜き出して、ルートパーティション(`Windows`の場合、`Desktop`フォルダ)をルートノードにして`JTree`で表示しています。

- クリックされたノードがディレクトリの場合、子ファイルの検索と`JTree`へのそれらの追加を`SwingWorker`を使用して別スレッドで実行する

<!-- dummy comment line for breaking list -->

## 参考リンク
- [FileSystemView (Java Platform SE 6)](http://docs.oracle.com/javase/jp/6/api/javax/swing/filechooser/FileSystemView.html)
- [java - File Browser GUI - Stack Overflow](https://stackoverflow.com/questions/6182110/file-browser-gui)
- [Showing the file system as a Swing JTree ・ Pushing Pixels](http://www.pushing-pixels.org/2007/07/22/showing-the-file-system-as-a-swing-jtree.html)

<!-- dummy comment line for breaking list -->

## コメント
