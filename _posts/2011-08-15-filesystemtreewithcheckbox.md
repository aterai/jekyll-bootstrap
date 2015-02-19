---
layout: post
category: swing
folder: FileSystemTreeWithCheckBox
title: JCheckBox付きJTreeでディレクトリ構造を表示
tags: [JTree, JCheckBox, TreeCellRenderer, TreeCellEditor, File, TreeModelListener, SwingWorker]
author: aterai
pubdate: 2011-08-15T15:43:03+09:00
description: 編集可能なJCheckBoxをノードに追加したJTreeでディレクトリ構造を表示します。
hreflang:
    href: http://java-swing-tips.blogspot.com/2011/08/filesystemtree-with-jcheckbox.html
    lang: en
comments: true
---
## 概要
編集可能な`JCheckBox`をノードに追加した`JTree`でディレクトリ構造を表示します。

{% download https://lh6.googleusercontent.com/-5ihZ2R-e4Ug/Tki-blUTxaI/AAAAAAAABA0/5KCjlm9CkSY/s800/FileSystemTreeWithCheckBox.png %}

## サンプルコード
<pre class="prettyprint"><code>class CheckBoxNodeEditor extends TriStateCheckBox implements TreeCellEditor {
  private final FileSystemView fileSystemView;
  private final JPanel panel = new JPanel(new BorderLayout());
  private DefaultTreeCellRenderer renderer = new DefaultTreeCellRenderer();
  private File file;
  public CheckBoxNodeEditor(FileSystemView fileSystemView) {
    super();
    this.fileSystemView = fileSystemView;
    this.addActionListener(new ActionListener() {
      @Override public void actionPerformed(ActionEvent e) {
        stopCellEditing();
      }
    });
    panel.setFocusable(false);
    panel.setRequestFocusEnabled(false);
    panel.setOpaque(false);
    panel.add(this, BorderLayout.WEST);
    this.setOpaque(false);
  }
  @Override public Component getTreeCellEditorComponent(
      JTree tree, Object value, boolean isSelected, boolean expanded,
      boolean leaf, int row) {
    JLabel l = (JLabel) renderer.getTreeCellRendererComponent(
      tree, value, true, expanded, leaf, row, true);
    l.setFont(tree.getFont());
    setOpaque(false);
    if (value instanceof DefaultMutableTreeNode) {
      this.setEnabled(tree.isEnabled());
      this.setFont(tree.getFont());
      Object userObject = ((DefaultMutableTreeNode) value).getUserObject();
      if (userObject instanceof CheckBoxNode) {
        CheckBoxNode node = (CheckBoxNode) userObject;
        if (node.status == Status.INDETERMINATE) {
          setIcon(new IndeterminateIcon());
        } else {
          setIcon(null);
        }
        file = node.file;
        l.setIcon(fileSystemView.getSystemIcon(file));
        l.setText(fileSystemView.getSystemDisplayName(file));
        setSelected(node.status == Status.SELECTED);
      }
      //panel.add(this, BorderLayout.WEST);
      panel.add(l);
      return panel;
    }
    return l;
  }
  @Override public Object getCellEditorValue() {
    return new CheckBoxNode(file, isSelected() ? Status.SELECTED : Status.DESELECTED);
  }
  @Override public boolean isCellEditable(EventObject e) {
    if (e instanceof MouseEvent &amp;&amp; e.getSource() instanceof JTree) {
      MouseEvent me = (MouseEvent) e;
      JTree tree = (JTree) e.getSource();
      TreePath path = tree.getPathForLocation(me.getX(), me.getY());
      Rectangle r = tree.getPathBounds(path);
      if (r == null) {
        return false;
      }
      Dimension d = getPreferredSize();
      r.setSize(new Dimension(d.width, r.height));
      if (r.contains(me.getX(), me.getY())) {
        if (file == null &amp;&amp; System.getProperty("java.version").startsWith("1.7.0")) {
          System.out.println("XXX: Java 7, only on first run\n" + getBounds());
          setBounds(new Rectangle(0, 0, d.width, r.height));
        }
        return true;
      }
    }
    return false;
  }
  @Override public void updateUI() {
    super.updateUI();
    if (panel != null) {
      panel.updateUI();
    }
    //1.6.0_24 bug??? @see 1.7.0 DefaultTreeCellRenderer#updateUI()
    renderer = new DefaultTreeCellRenderer();
  }
//......
</code></pre>

## 解説
このサンプルは、[FileSystemViewを使ってディレクトリ構造をJTreeに表示する](http://ateraimemo.com/Swing/DirectoryTree.html)と、[JTreeの葉ノードをJCheckBoxにする](http://ateraimemo.com/Swing/CheckBoxNodeTree.html)を組み合わせて作成しています。

- - - -
`TreeCellEditor#isCellEditable(...)`をオーバーライドして、`JCheckBox`付近をクリックした場合のみ編集可能(チェックの有無を切り替えることができる)にし、ラベルやアイコンなどをクリックした場合は、編集状態にせずノードの展開や折り畳みができるように設定しています。

## 参考リンク
- [FileSystemViewを使ってディレクトリ構造をJTreeに表示する](http://ateraimemo.com/Swing/DirectoryTree.html)
- [JTreeの葉ノードをJCheckBoxにする](http://ateraimemo.com/Swing/CheckBoxNodeTree.html)

<!-- dummy comment line for breaking list -->

## コメント
- [JTreeのすべてのノードにJCheckBoxを追加する](http://ateraimemo.com/Swing/CheckBoxNodeEditor.html) で使用している`TreeModelListener`を追加して`JCheckBox`の状態を変更するように修正。 -- *aterai* 2012-04-13 (金) 20:12:08
- チェックされたノード(最上位となる)の一覧をコンソールに表示する`JButton`を追加(スクリーンショットなどは面倒なので更新しない)。 -- *aterai* 2012-04-19 (木) 19:50:07
- ノードをチェックしてから、そのディレクトリを開いても子ディレクトリにチェックが反映されない。 -- *aterai* 2012-07-31 (火) 18:15:44
- いつも勉強させていただいております。サンプルでは`root`はデスクトップとなっていますが、もし例えば`Z:\`または`Z:\aaa`と`TOP`にしたい場合、どこを修正すれば宜しいでしょうか？ご教示をお願いいたします。 -- *Tiger* 2013-12-25 (水) 14:11:08
    - こんばんは。このサンプルでは、`fileSystemView.getRoots()`で`Desktop`フォルダ(`Windows`の場合)を取得しているので、この箇所を、例えば`File fileSystemRoot = new File("Z:/"); /* for(File fileSystemRoot: fileSystemView.getRoots()) */ {`のように変更するのはどうでしょうか。 -- *aterai* 2013-12-25 (水) 16:34:38
- ご教示、ありがとうございました。ご指摘のところを見落としました。やり方は理解できました。ついでに、もし`root`はデスクトップにしておいて、`C:\`を表示させないで(または展開させないで)、`X:\`,`Y:\`のみ操作させるには、どこを弄れば宜しいでしょうか？ありがとうございました。来年もよろしくお願いします。 -- *Tiger* 2013-12-26 (木) 13:36:28
    - `fileSystemView.getRoots()`で`Desktop`フォルダを取得すると、 マイコンピュータとか、`Desktop`フォルダが`C:\`にある場合はマイドキュメントなどを選択不可にするのが、面倒な気がします。以下のように`new File(System.getProperty("user.home")+"/Desktop")`とデスクトップを決め打ちにしてノードを作ってしまうのが簡単かもしれません。 -- *aterai* 2013-12-26 (木) 21:55:24

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>final FileSystemView fileSystemView = FileSystemView.getFileSystemView();
DefaultMutableTreeNode root = new DefaultMutableTreeNode();
final DefaultTreeModel treeModel = new DefaultTreeModel(root);
File desktopFile = new File(System.getProperty("user.home")+"/Desktop");
DefaultMutableTreeNode desktop = new DefaultMutableTreeNode(new CheckBoxNode(desktopFile, Status.DESELECTED));
root.add(desktop);
for (File file: fileSystemView.getFiles(desktopFile, true)) {
  if (file.isDirectory()) {
    desktop.add(new DefaultMutableTreeNode(new CheckBoxNode(file, Status.DESELECTED)));
  }
}
for (File fileSystemRoot: Arrays.asList(new File("X:/"), new File("Y:/"))) {
  DefaultMutableTreeNode node = new DefaultMutableTreeNode(new CheckBoxNode(fileSystemRoot, Status.DESELECTED));
  desktop.add(node);
  for (File file: fileSystemView.getFiles(fileSystemRoot, true)) {
    System.out.println(file.getAbsolutePath());
    if (file.isDirectory()) {
      node.add(new DefaultMutableTreeNode(new CheckBoxNode(file, Status.DESELECTED)));
    }
  }
}
treeModel.addTreeModelListener(new CheckBoxStatusUpdateListener());
</code></pre>
- いつも勉強させていただいております。チェックしたファイルまたはフォルダーのチェックマークの外し方を教えていただけませんか？ -- *Tiger* 2014-03-04 (火) 13:55:30
    - こんばんは。マウスを使わずにチェックを外したいということですよね。このサンプルの場合、`MutableTreeNode#setUserObject(...)`でチェックを外した`new CheckBoxNode(node.file, Status.DESELECTED)`を設定し、そのあと[DefaultTreeModel#nodeChanged(...) (Java Platform SE 7)](http://docs.oracle.com/javase/jp/7/api/javax/swing/tree/DefaultTreeModel.html#nodeChanged%28javax.swing.tree.TreeNode%29)を呼べばいいと思います。 -- *aterai* 2014-03-05 (水) 18:23:39

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>//例えば、すべてのチェックを外す場合...
private static void deselectedAll(DefaultTreeModel model, TreePath path) {
  Object o = path.getLastPathComponent();
  if (!(o instanceof DefaultMutableTreeNode)) {
    return;
  }
  DefaultMutableTreeNode node = (DefaultMutableTreeNode) o;
  o = node.getUserObject();
  if (!(o instanceof CheckBoxNode)) {
    return;
  }
  CheckBoxNode check = (CheckBoxNode) o;
  if (check.status == Status.SELECTED) {
    node.setUserObject(new CheckBoxNode(check.file, Status.DESELECTED));
    model.nodeChanged(node);
    //or: model.valueForPathChanged(path, new CheckBoxNode(check.file, Status.DESELECTED));
  } else if (!node.isLeaf() &amp;&amp; node.getChildCount() &gt;= 0) {
    Enumeration e = node.children();
    while (e.hasMoreElements()) {
      deselectedAll(model, path.pathByAddingChild(e.nextElement()));
    }
  }
}
</code></pre>
