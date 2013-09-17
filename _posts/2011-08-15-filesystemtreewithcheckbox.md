---
layout: post
title: JCheckBox付きJTreeでディレクトリ構造を表示
category: swing
folder: FileSystemTreeWithCheckBox
tags: [JTree, JCheckBox, TreeCellRenderer, TreeCellEditor, File, TreeModelListener]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2011-08-15

## JCheckBox付きJTreeでディレクトリ構造を表示
編集可能な`JCheckBox`をノードに追加した`JTree`でディレクトリ構造を表示します。

- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/-5ihZ2R-e4Ug/Tki-blUTxaI/AAAAAAAABA0/5KCjlm9CkSY/s800/FileSystemTreeWithCheckBox.png)

### サンプルコード
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
    JLabel l = (JLabel)renderer.getTreeCellRendererComponent(
        tree, value, true, expanded, leaf, row, true);
    l.setFont(tree.getFont());
    setOpaque(false);
    if(value != null &amp;&amp; value instanceof DefaultMutableTreeNode) {
      this.setEnabled(tree.isEnabled());
      this.setFont(tree.getFont());
      Object userObject = ((DefaultMutableTreeNode)value).getUserObject();
      if(userObject!=null &amp;&amp; userObject instanceof CheckBoxNode) {
        CheckBoxNode node = (CheckBoxNode)userObject;
        if(node.status==Status.INDETERMINATE) {
          setIcon(new IndeterminateIcon());
        }else{
          setIcon(null);
        }
        file = node.file;
        l.setIcon(fileSystemView.getSystemIcon(file));
        l.setText(fileSystemView.getSystemDisplayName(file));
        setSelected(node.status==Status.SELECTED);
      }
      //panel.add(this, BorderLayout.WEST);
      panel.add(l);
      return panel;
    }
    return l;
  }
  @Override public Object getCellEditorValue() {
    return new CheckBoxNode(file, isSelected()?Status.SELECTED:Status.DESELECTED);
  }
  @Override public boolean isCellEditable(EventObject e) {
    if(e != null &amp;&amp; e instanceof MouseEvent &amp;&amp; e.getSource() instanceof JTree) {
      MouseEvent me = (MouseEvent)e;
      JTree tree = (JTree)e.getSource();
      TreePath path = tree.getPathForLocation(me.getX(), me.getY());
      Rectangle r = tree.getPathBounds(path);
      if(r==null) return false;
      Dimension d = getPreferredSize();
      r.setSize(new Dimension(d.width, r.height));
      if(r.contains(me.getX(), me.getY())) {
        if(file==null &amp;&amp; System.getProperty("java.version").startsWith("1.7.0")) {
          System.out.println("XXX: Java 7, only on first run\n"+getBounds());
          setBounds(new Rectangle(0,0,d.width,r.height));
        }
        return true;
      }
    }
    return false;
  }
  @Override public void updateUI() {
    super.updateUI();
    if(panel!=null) panel.updateUI();
    //1.6.0_24 bug??? @see 1.7.0 DefaultTreeCellRenderer#updateUI()
    renderer = new DefaultTreeCellRenderer();
  }
//......
</code></pre>

### 解説
このサンプルは、[FileSystemViewを使ってディレクトリ構造をJTreeに表示する](http://terai.xrea.jp/Swing/DirectoryTree.html)と、[JTreeの葉ノードをJCheckBoxにする](http://terai.xrea.jp/Swing/CheckBoxNodeTree.html)を組み合わせて作成しています。
- - - -
`TreeCellEditor#isCellEditable(...)`をオーバーライドして、`JCheckBox`付近をクリックした場合のみ編集可能(チェックの有無を切り替えることができる)にし、ラベールやアイコンなどをクリックした場合は、編集状態にせずノードの展開や折り畳みができるように設定しています。
- - - -
~~[JTableHeaderにJCheckBoxを追加してセルの値を切り替える](http://terai.xrea.jp/Swing/TableHeaderCheckBox.html)のように親ノードをチェックすると子ノードのチェックをすべて切り替える機能には今のところ対応していません。~~
- 対応済み

<!-- dummy comment line for breaking list -->

### 参考リンク
- [FileSystemViewを使ってディレクトリ構造をJTreeに表示する](http://terai.xrea.jp/Swing/DirectoryTree.html)
- [JTreeの葉ノードをJCheckBoxにする](http://terai.xrea.jp/Swing/CheckBoxNodeTree.html)

<!-- dummy comment line for breaking list -->

### コメント
- [JTreeのすべてのノードにJCheckBoxを追加する](http://terai.xrea.jp/Swing/CheckBoxNodeEditor.html) で使用している`TreeModelListener`を追加して`JCheckBox`の状態を変更するように修正。 -- [aterai](http://terai.xrea.jp/aterai.html) 2012-04-13 (金) 20:12:08
- チェックされたノード(最上位となる)の一覧をコンソールに表示する`JButton`を追加(スクリーンショットなどは面倒なので更新しない)。 -- [aterai](http://terai.xrea.jp/aterai.html) 2012-04-19 (木) 19:50:07
- ノードをチェックしてから、そのディレクトリを開いても子ディレクトリにチェックが反映されない。 -- [aterai](http://terai.xrea.jp/aterai.html) 2012-07-31 (火) 18:15:44

<!-- dummy comment line for breaking list -->

