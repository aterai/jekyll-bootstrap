---
layout: post
title: JComboBoxの色を変更
category: swing
folder: ColorComboBox
tags: [JComboBox, ListCellRenderer, JTextField]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-01-10

## JComboBoxの色を変更
`JComboBox`の`Editor`部分と、`List`部分の色を変更します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh4.ggpht.com/_9Z4BYR88imo/TQTJhY0CAaI/AAAAAAAAAUg/J70FCr-EUlI/s800/ColorComboBox.png)

### サンプルコード
<pre class="prettyprint"><code>combo01.setModel(makeModel());
combo01.setRenderer(new MyListCellRenderer(combo01.getRenderer()));
combo01.addItemListener(new ItemListener() {
  @Override public void itemStateChanged(ItemEvent e) {
    if(e.getStateChange()!=ItemEvent.SELECTED) return;
    combo01.setBackground(getOEColor(combo01.getSelectedIndex()));
  }
});
combo01.setSelectedIndex(0);
combo01.setBackground(evenBGColor);

final JTextField field = (JTextField) combo02.getEditor().getEditorComponent();
field.setOpaque(true);
field.setBackground(evenBGColor);
combo02.setEditable(true);
combo02.setModel(makeModel());
combo02.setRenderer(new MyListCellRenderer(combo02.getRenderer()));
combo02.addItemListener(new ItemListener() {
  @Override public void itemStateChanged(ItemEvent e) {
    if(e.getStateChange()!=ItemEvent.SELECTED) return;
    field.setBackground(getOEColor(combo02.getSelectedIndex()));
  }
});
combo02.setSelectedIndex(0);
</code></pre>

### 解説
`JComboBox`を編集可にした状態で、以下のように`List`部分、`Editor`部分に背景色を設定します。

- `List`部分
    - `ListCellRenderer`を使用することで背景色を変更しています。

<!-- dummy comment line for breaking list -->

- `Editor`部分
    - `getEditor().getEditorComponent()`で`JTextField`オブジェクトを取得して背景色を変更しています。

<!-- dummy comment line for breaking list -->

上記のサンプルでは、下の`JComboBox`で行の奇数偶数による背景色の変更を行っています。

- - - -
`GTKLookAndFeel`などで、うまく`Box`(`Editor`)部分の色を変更できない場合があるようです。

![screenshot](http://lh3.ggpht.com/_9Z4BYR88imo/TQTJj4vDxSI/AAAAAAAAAUk/ZZtKylfc0k8/s800/ColorComboBox1.png)

### 参考リンク
- [JComboBoxの文字色を変更する](http://terai.xrea.jp/Swing/ComboBoxForegroundColor.html)

<!-- dummy comment line for breaking list -->

### コメント
- `JComboBox#setEditable(true)`は必須のようです。編集不可にするには`Editor`部分の`JTextField`に対して`setEditable(false)` -- [Y](http://terai.xrea.jp/Y.html) 2006-10-10 (火) 18:51:38
    - ご指摘ありがとうございます。せっかく`JComboBox`を上下に並べているのだから、編集可の場合と不可の場合のサンプルにすればよかったですね。編集不可の場合(`JComboBox#setEditable(false)`)に色を着けるには、上記の方法と、以下のように`JComboBox#setBackground(Color)`メソッドを使う方法があるようです。~~編集不可の場合は、この部分の色もレンダラーが勝手にやってくれてたような気がするのですが、勘違いだったのかも。~~ バージョンや`LookAndFeel`で異なる？ようです。 -- [aterai](http://terai.xrea.jp/aterai.html) 2006-10-10 (火) 19:58:51

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>final JComboBox c = new JComboBox();
c.addItemListener(new ItemListener() {
  @Override public void itemStateChanged(ItemEvent e) {
    if(e.getStateChange()!=ItemEvent.SELECTED) return;
    c.setBackground((c.getSelectedIndex()%2==0)?evenBGColor:oddBGColor);
  }
});
</code></pre>

    - せっかくなので、上の`JComboBox`は編集不可、下は編集可の場合で、色を着けるサンプルに変更しました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2006-10-10 (火) 20:31:03
- メモ:[Windows/Motif L&F: Changing the JComboBox background does not change the popup of the JCombobox](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6367601) -- [aterai](http://terai.xrea.jp/aterai.html) 2007-12-13 (木) 15:43:50
- サンプルソースの`LookAndFeel`を設定しないようにすると、編集不可コンボはボタン部分も背景色になってしまう・・ -- [han](http://terai.xrea.jp/han.html) 2008-10-21 (火) 10:41:38
    - `MetalLookAndFeel`などは、コンボボックスの背景色を変更すると矢印ボタンの色まで変更してしまう仕様？みたいですね。回避するなら、以下のように`UI`で使っている`PropertyChangeListener`をオーバーライドしてしまうのはどうでしょう。 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-10-21 (火) 15:41:21

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>combo01.setUI(new MetalComboBoxUI() {
  @Override public PropertyChangeListener createPropertyChangeListener() {
    return new MetalPropertyChangeListener() {
      @Override public void propertyChange(PropertyChangeEvent e) {
        String propertyName = e.getPropertyName();
        if(propertyName=="background") {
          Color color = (Color)e.getNewValue();
          //arrowButton.setBackground(color);
          listBox.setBackground(color);
        }else{
          super.propertyChange( e );
        }
      }
    };
  }
});
combo01.setModel(makeModel());
combo01.setRenderer(new MyListCellRenderer(combo01.getRenderer()));
combo01.addItemListener(new ItemListener() {
  @Override public void itemStateChanged(ItemEvent e) {
    if(e.getStateChange()!=ItemEvent.SELECTED) return;
    combo01.setBackground(getOEColor(combo01.getSelectedIndex()));
  }
});
combo01.setSelectedIndex(0);
combo01.setBackground(evenBGColor);
</code></pre>

- ありがとうございます。動作確認してませんが`UI`をさわればいろんなことができそうですね。で`UIManager`でなんとかできないか気になったので試すと、`UIManager.put("ComboBox.background", new ColorUIResource(Color.white));`で全てのコンボボックスの背景色を設定できました（リストの色分けはできないですが） -- [han](http://terai.xrea.jp/han.html) 2008-10-24 (金) 11:28:10

<!-- dummy comment line for breaking list -->

