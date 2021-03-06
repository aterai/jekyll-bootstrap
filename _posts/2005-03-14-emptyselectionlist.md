---
layout: post
category: swing
folder: EmptySelectionList
title: JListを選択不可にする
tags: [JList, ListCellRenderer, ListSelectionModel]
author: aterai
pubdate: 2005-03-14T14:24:03+09:00
description: JListのセルアイテムをマウスクリックで選択不可に設定します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTMI697_II/AAAAAAAAAYs/EhpPEXnw1bc/s800/EmptySelectionList.png
comments: true
---
## 概要
`JList`のセルアイテムをマウスクリックで選択不可に設定します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTMI697_II/AAAAAAAAAYs/EhpPEXnw1bc/s800/EmptySelectionList.png %}

## サンプルコード
<pre class="prettyprint"><code>list2.setFocusable(false);
list2.setSelectionModel(new DefaultListSelectionModel() {
  @Override public boolean isSelectedIndex(int index) {
    return false;
  }
});

class EmptySelectionRenderer implements ListCellRenderer {
  private final ListCellRenderer renderer;
  public EmptySelectionRenderer(ListCellRenderer renderer) {
    this.renderer = renderer;
  }
  @Override public Component getListCellRendererComponent(
                     JList list, Object value, int index,
                     boolean isSelected, boolean cellHasFocus) {
    return renderer.getListCellRendererComponent(
                        list, value, index, false, false);
  }
}
</code></pre>

## 解説
- 左
    - `JList#setEnabled(false)`で編集不可にしているため、アイテムの選択も不可
    - 文字色が薄くなる
- 中
    - `JList#setFocusable(false)`でフォーカス無し、かつ`ListSelectionModel#isSelectedIndex(...)`が常に`false`なセレクションモデルを使用して選択不可に設定
- 右
    - 常に各セルを選択状態でもフォーカスも無いものとして描画するセルレンダラーを使用して選択不可に見せかける

<!-- dummy comment line for breaking list -->

- - - -
`LookAndFeel`が`Nimbus`の場合、編集不可にした`JList`の文字色を以下のような方法で変更できます。

<pre class="prettyprint"><code>import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.plaf.*;
public class DisabledTextForegroundList {
  public JComponent makeUI() {
    JList list = new JList(makeTestModel());
    //list.putClientProperty("Nimbus.Overrides", d);
    //list.putClientProperty("Nimbus.Overrides.InheritDefaults", false);
    list.setEnabled(false);
    JSplitPane p = new JSplitPane();
    p.setLeftComponent(new JScrollPane(new JList(makeTestModel())));
    p.setRightComponent(new JScrollPane(list));
    p.setResizeWeight(.5);
    return p;
  }
  private static ListModel makeTestModel() {
    DefaultListModel m = new DefaultListModel();
    m.addElement("aaaaaaaaaaaa"); m.addElement("bbbbb");
    return m;
  }
  public static void main(String[] args) {
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        createAndShowGUI();
      }
    });
  }
  public static void createAndShowGUI() {
    try {
      for (UIManager.LookAndFeelInfo laf : UIManager.getInstalledLookAndFeels())
        if ("Nimbus".equals(laf.getName()))
          UIManager.setLookAndFeel(laf.getClassName());
      //UIDefaults d = new UIDefaults();
      UIDefaults d = UIManager.getLookAndFeelDefaults();
      d.put("List:\"List.cellRenderer\"[Disabled].textForeground",
            new ColorUIResource(Color.RED));
    } catch (Exception e) {
      e.printStackTrace();
    }
    JFrame f = new JFrame();
    f.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
    f.getContentPane().add(new DisabledTextForegroundList().makeUI());
    f.setSize(320, 240);
    f.setLocationRelativeTo(null);
    f.setVisible(true);
  }
}
</code></pre>

## 参考リンク
- [JListの任意のItemを選択不可にする](https://ateraimemo.com/Swing/DisabledItem.html)

<!-- dummy comment line for breaking list -->

## コメント
