---
layout: post
category: swing
folder: TreeComboBox
title: JComboBoxのItemをTree状に表示する
tags: [JComboBox, TreeModel]
author: aterai
pubdate: 2011-07-11T15:16:42+09:00
description: JComboBoxのドロップダウンリストに表示するItemをTree状に配置します。
image: https://lh6.googleusercontent.com/-5GlQEjeLoH8/ThqUIL9b4UI/AAAAAAAAA_E/9h5dxYzSSm8/s800/TreeComboBox.png
comments: true
---
## 概要
`JComboBox`のドロップダウンリストに表示する`Item`を`Tree`状に配置します。

{% download https://lh6.googleusercontent.com/-5GlQEjeLoH8/ThqUIL9b4UI/AAAAAAAAA_E/9h5dxYzSSm8/s800/TreeComboBox.png %}

## サンプルコード
<pre class="prettyprint"><code>class TreeComboBox&lt;E extends TreeNode&gt; extends JComboBox&lt;E&gt; {
  private boolean isNotSelectableIndex;
  private final Action up = new AbstractAction() {
    @Override public void actionPerformed(ActionEvent e) {
      int si = getSelectedIndex();
      for (int i = si - 1; i &gt;= 0; i--) {
        if (getItemAt(i).isLeaf()) {
          setSelectedIndex(i);
          break;
        }
      }
    }
  };

  private final Action down = new AbstractAction() {
    @Override public void actionPerformed(ActionEvent e) {
      int si = getSelectedIndex();
      for (int i = si + 1; i &lt; getModel().getSize(); i++) {
        if (getItemAt(i).isLeaf()) {
          setSelectedIndex(i);
          break;
        }
      }
    }
  };

  @Override public void updateUI() {
    super.updateUI();
    ListCellRenderer&lt;? super E&gt; renderer = getRenderer();
    setRenderer(new ListCellRenderer&lt;E&gt;() {
      @Override public Component getListCellRendererComponent(
          JList&lt;? extends E&gt; list, E value, int index,
          boolean isSelected, boolean cellHasFocus) {
        JLabel l = (JLabel) renderer.getListCellRendererComponent(
            list, value, index, isSelected, cellHasFocus);
        l.setBorder(BorderFactory.createEmptyBorder(1, 1, 1, 1));
        if (index &gt;= 0 &amp;&amp; value instanceof DefaultMutableTreeNode) {
          DefaultMutableTreeNode node = (DefaultMutableTreeNode) value;
          int indent = Math.max(0, node.getLevel() - 1) * 16;
          l.setBorder(BorderFactory.createEmptyBorder(1, indent + 1, 1, 1));
          if (!value.isLeaf()) {
            l.setForeground(Color.WHITE);
            l.setBackground(Color.GRAY.darker());
          }
        }
        return l;
      }
    });
    EventQueue.invokeLater(() -&gt; {
      ActionMap am = getActionMap();
      am.put("selectPrevious3", up);
      am.put("selectNext3", down);
      InputMap im = getInputMap();
      im.put(KeyStroke.getKeyStroke(KeyEvent.VK_UP, 0), "selectPrevious3");
      im.put(KeyStroke.getKeyStroke(KeyEvent.VK_KP_UP, 0), "selectPrevious3");
      im.put(KeyStroke.getKeyStroke(KeyEvent.VK_DOWN, 0), "selectNext3");
      im.put(KeyStroke.getKeyStroke(KeyEvent.VK_KP_DOWN, 0), "selectNext3");
    });
  }

  @Override public void setPopupVisible(boolean v) {
    if (!v &amp;&amp; isNotSelectableIndex) {
      isNotSelectableIndex = false;
    } else {
      super.setPopupVisible(v);
    }
  }

  @Override public void setSelectedIndex(int index) {
    TreeNode node = getItemAt(index);
    if (Objects.nonNull(node) &amp;&amp; node.isLeaf()) {
      super.setSelectedIndex(index);
    } else {
      isNotSelectableIndex = true;
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、`TreeModel`から取得した`TreeNode`を`JComboBox`の`Item`として、ドロップダウンリストに表示しています。

- `TreeNode#isLeaf()`の場合だけ、選択可能
    - [JComboBoxのアイテムを選択不可にする](https://ateraimemo.com/Swing/DisableItemComboBox.html)
- 第`0`レベルのルートノードは非表示で、第`1`レベルノードのインデントは`0`に設定
- 第`2`レベル以降の子ノードのインデントは`BorderFactory.createEmptyBorder(1, indent + 1, 1, 1)`で設定

<!-- dummy comment line for breaking list -->

- - - -
- `TreeCellRenderer`を使用してノードアイコンなどを表示する場合のサンプル

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>import java.awt.*;
import java.util.Arrays;
import java.util.Collections;
import java.util.Enumeration;
import java.util.Objects;
import java.util.stream.Collectors;
import javax.swing.*;
import javax.swing.tree.DefaultMutableTreeNode;
import javax.swing.tree.TreeCellRenderer;

public final class TreeComboBoxTest {
  private Component makeUI() {
    DefaultMutableTreeNode root = (DefaultMutableTreeNode) new JTree().getModel().getRoot();
    JPanel p = new JPanel(new BorderLayout());
    p.add(new TreeComboBox(root), BorderLayout.NORTH);
    p.setBorder(BorderFactory.createEmptyBorder(5, 5, 5, 5));
    return p;
  }

  public static void main(String[] args) {
    EventQueue.invokeLater(() -&gt; {
      try {
        UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
      } catch(Exception ex) {
        throw new IllegalArgumentException(ex);
      }
      JFrame f = new JFrame();
      f.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
      f.getContentPane().add(new TreeComboBoxTest().makeUI());
      f.setSize(320, 240);
      f.setLocationRelativeTo(null);
      f.setVisible(true);
    });
  }
}

class TreeComboBox extends JComboBox&lt;DefaultMutableTreeNode&gt; {
  public TreeComboBox(DefaultMutableTreeNode root) {
    super();
    DefaultComboBoxModel&lt;DefaultMutableTreeNode&gt; m = new DefaultComboBoxModel&lt;&gt;();
    Collections.list((Enumeration&lt;?&gt;) root.preorderEnumeration()).stream()
        .filter(DefaultMutableTreeNode.class::isInstance)
        .map(DefaultMutableTreeNode.class::cast)
        .filter(n -&gt; !n.isRoot())
        .forEach(m::addElement);
    setModel(m);
  }

  @Override
  public void updateUI() {
    super.updateUI();
    JTree dummyTree = new JTree();
    TreeCellRenderer renderer = dummyTree.getCellRenderer();
    ListCellRenderer&lt;? super DefaultMutableTreeNode&gt; r = getRenderer();
    setRenderer((list, value, index, isSelected, cellHasFocus) -&gt; {
      Component c = r.getListCellRendererComponent(list, value, index, isSelected, cellHasFocus);
      if (value == null) {
        return c;
      }
      if (index &lt; 0) {
        String txt = Arrays.stream(value.getPath())
            .filter(DefaultMutableTreeNode.class::isInstance)
            .map(DefaultMutableTreeNode.class::cast)
            .filter(n -&gt; !n.isRoot())
            .map(Objects::toString)
            .collect(Collectors.joining(" / "));
        ((JLabel) c).setText(txt);
        return c;
      } else {
        boolean leaf = value.isLeaf();
        JLabel l = (JLabel) renderer.getTreeCellRendererComponent(
            dummyTree, value, isSelected, true, leaf, index, false);
        int childIndent = UIManager.getInt("Tree.leftChildIndent") +
                          UIManager.getInt("Tree.rightChildIndent");
        int indent = Math.max(0, value.getLevel() - 1) * childIndent;
        l.setBorder(BorderFactory.createEmptyBorder(1, indent + 1, 1, 1));
        return l;
      }
    });
  }
}
</code></pre>

## 参考リンク
- [Tree inside JComboBox - Santhosh Kumar's Weblog](http://www.jroller.com/santhosh/entry/tree_inside_jcombobox)
    - `TreeCellRenderer`を使用し、ノードアイコンなども含めて`JTree`をドロップダウンリストに表示するサンプルがある
- [JComboBoxのアイテムを選択不可にする](https://ateraimemo.com/Swing/DisableItemComboBox.html)

<!-- dummy comment line for breaking list -->

## コメント
- `src.zip`などが正しいディレクトリに配置されてなかったのを修正。 -- *aterai* 2011-07-13 (水) 19:02:23

<!-- dummy comment line for breaking list -->
