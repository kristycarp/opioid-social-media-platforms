library(ggplot2)
library(ggrepel)
library(scales)

labels = c("Facebook",
           "YouTube",
           "Instagram",
           "TikTok",
           "X (Twitter)",
           "Pinterest",
           "LinkedIn",
           "Reddit",
           "drugs-forum",
           "Tumblr",
           "Bluelight")
formal_ratio_scaled = c(4112.711541,
                        1081.382706,
                        348.9246767,
                        2013.421214,
                        1505.616777,
                        719.9170538,
                        871.451767,
                        2258.812334,
                        105523.661,
                        1458.086556,
                        103825.4862)
informal_algospeak_ratio_scaled = c(1431.090622,
                          190.3829712,
                          147.0379566,
                          1030.163131,
                          162.6401231,
                          157.0057437,
                          181.3090403,
                          217.1399204,
                          32378.02641,
                          115.8213628,
                          46272.7738)
informal_ratio_scaled = c(1427.505509,
                                     190.2547695,
                                     146.1056591,
                                     1018.447419,
                                     161.8239978,
                                     156.7172058,
                                     181.1653793,
                                     217.0050398,
                                     32378.02641,
                                     115.6608349,
                                     46236.18219)
algospeak_ratio_scaled = c(3.585113529,
                                  0.1282017311,
                                  0.9322975564,
                                  11.71571185,
                                  0.8161252375,
                                  0.2885378833,
                                  0.1436609775,
                                  0.1348806366,
                                  0,
                                  0.1605279312,
                                  36.59160696)

total_formal = c(61221824,
                 122434150,
                 7096779,
                 17748308,
                 16638571,
                 8523098,
                 41970860,
                 34062890,
                 115063,
                 4750446,
                 405750)
total_informal_algospeak = c(21303215,
                   21555160,
                   2990605,
                   9080888,
                   1797336,
                   1858791,
                   8732206,
                   3274470,
                   35305,
                   377346,
                   180834)
total_algospeak = c(53368,
                  14515,
                  18962,
                  103274,
                  9019,
                  3416,
                  6919,
                  2034,
                  0,
                  523,
                  143)
total_informal = c(21249847,
                     21540645,
                     2971643,
                     8977614,
                     1788317,
                     1855375,
                     8725287,
                     3272436,
                     35305,
                     376823,
                     180691)

informal_algospeak_vs_formal_df = data.frame(x=formal_ratio_scaled,
                                   y=informal_algospeak_ratio_scaled,
                                   label=labels)
informal_algospeak_vs_formal_totals_df = data.frame(x=total_formal,
                                   y=total_informal_algospeak,
                                   label=labels)
algospeak_vs_informal_totals_df = data.frame(x=total_algospeak,
                                          y=total_informal,
                                          label=labels)
algospeak_vs_informal_df = data.frame(x=algospeak_ratio_scaled,
                                      y=informal_ratio_scaled,
                                      label=labels)


ggplot(informal_algospeak_vs_formal_df, aes(x=x,y=y,label=label,color=label)) +
  geom_abline(slope = 1, linetype = "dotted", color = "black") +
  geom_text_repel(box.padding = 0.3, segment.color = "darkgray",size=7) +
  geom_point() +
  scale_color_manual(values = c("Facebook" = "#192BC2",
                                "X (Twitter)" = "#449DD1",
                                "TikTok" = "#192BC2",
                                "Pinterest" = "#449DD1",
                                "YouTube" = "#192BC2",
                                "Instagram" = "#449DD1",
                                "LinkedIn" = "#192BC2",
                                "Tumblr" = "#449DD1",
                                "Reddit" = "#192BC2",
                                "Bluelight" = "#A0CEE2",
                                "drugs-forum" = "#A0CEE2")) +
  labs(x="Formal Normalized Ratio, Scaled",
       y="Informal+Algospeak \nNormalized Ratio, Scaled") +
  guides(color = "none") +
  scale_x_continuous(trans = pseudo_log_trans(base = 10),
                     breaks = trans_breaks("log10",function(x) 10^x),
                     labels = trans_format("log10",math_format(10^.x))) +
  scale_y_continuous(trans = pseudo_log_trans(base = 10),
                     breaks = trans_breaks("log10",function(x) 10^x),
                     labels = trans_format("log10",math_format(10^.x))) +
  coord_cartesian(xlim = c(10^2, 10^5), ylim = c(10^2, 10^5)) +
  theme_minimal() +
  theme(plot.margin = margin(1, 1, 0.5, 0.5, "cm"),
        axis.text = element_text(size=14),
        axis.title = element_text(size=20),
        axis.line = element_line(size = 1, color = "black"))


ggplot(algospeak_vs_informal_df, aes(x=x,y=y,label=label,color=label)) +
  geom_abline(slope = 1, linetype = "dotted", color = "black") +
  geom_text_repel(box.padding = 0.7, segment.color = "darkgray",size=6) +
  geom_point() +
  scale_color_manual(values = c("Facebook" = "#192BC2",
                                "X (Twitter)" = "#449DD1",
                                "TikTok" = "#192BC2",
                                "Pinterest" = "#449DD1",
                                "YouTube" = "#192BC2",
                                "Instagram" = "#449DD1",
                                "LinkedIn" = "#192BC2",
                                "Tumblr" = "#449DD1",
                                "Reddit" = "#192BC2",
                                "Bluelight" = "#A0CEE2",
                                "drugs-forum" = "#A0CEE2")) +
  labs(x="Algospeak Normalized Ratio, Scaled",
       y="Informal Normalized Ratio, Scaled") +
  guides(color = "none") +
  scale_x_continuous(trans = pseudo_log_trans(base = 10),
                     breaks = c(0, 2, 5, 10, 15, 30)) +
  scale_y_continuous(trans = pseudo_log_trans(base = 10),
                     breaks = c(10, 100, 1000, 10000, 100000),
                     labels = trans_format("log10",math_format(10^.x))) +
  coord_cartesian(xlim = c(0, 10^1.5), ylim = c(0, 10^5)) +
  theme_minimal() +
  theme(plot.margin = margin(1, 1, 0.5, 0.5, "cm"),
        axis.text = element_text(size=14),
        axis.title = element_text(size=20),
        axis.line = element_line(size = 1, color = "black"))




# total (instead of relative)
ggplot(informal_algospeak_vs_formal_totals_df, aes(x=x,y=y,label=label,color=label)) +
  geom_abline(slope = 1, linetype = "dotted", color = "black") +
  geom_text_repel(box.padding = 0.6, segment.color = "darkgray", size=8) +
  geom_point() +
  scale_color_manual(values = c("Facebook" = "#192BC2",
                                "X (Twitter)" = "#449DD1",
                                "TikTok" = "#192BC2",
                                "Pinterest" = "#449DD1",
                                "YouTube" = "#192BC2",
                                "Instagram" = "#449DD1",
                                "LinkedIn" = "#192BC2",
                                "Tumblr" = "#449DD1",
                                "Reddit" = "#192BC2",
                                "Bluelight" = "#A0CEE2",
                                "drugs-forum" = "#A0CEE2")) +
  labs(x="Total Formal Hits",
       y="Total Informal+Algospeak Hits") +
  guides(color = "none") +
  scale_x_continuous(trans = pseudo_log_trans(base = 10),
                     breaks = c(10^4, 10^5, 10^6, 10^7, 10^8),
                     labels = trans_format("log10",math_format(10^.x))) +
  scale_y_continuous(trans = pseudo_log_trans(base = 10),
                     breaks = c(10^4, 10^5, 10^6, 10^7, 10^8),
                     labels = trans_format("log10",math_format(10^.x))) +
  coord_cartesian(xlim = c(10^4, 10^8), ylim = c(10^4, 10^8)) +
  theme_minimal() +
  theme(plot.margin = margin(1, 1, 0.5, 0.5, "cm"),
        axis.text = element_text(size=14),
        axis.title = element_text(size=20),
        axis.line = element_line(size = 1, color = "black"))

ggplot(algospeak_vs_informal_totals_df, aes(x=x,y=y,label=label,color=label)) +
  geom_abline(slope = 1, linetype = "dotted", color = "black") +
  geom_text_repel(box.padding = 0.2, segment.color = "darkgray",size=7) +
  geom_point() +
  scale_color_manual(values = c("Facebook" = "#192BC2",
                                "X (Twitter)" = "#449DD1",
                                "TikTok" = "#192BC2",
                                "Pinterest" = "#449DD1",
                                "YouTube" = "#192BC2",
                                "Instagram" = "#449DD1",
                                "LinkedIn" = "#192BC2",
                                "Tumblr" = "#449DD1",
                                "Reddit" = "#192BC2",
                                "Bluelight" = "#A0CEE2",
                                "drugs-forum" = "#A0CEE2")) +
  labs(x="Total Algospeak Hits",
       y="Total Informal Hits") +
  guides(color = "none") +
  scale_x_continuous(trans = pseudo_log_trans(base = 10),
                     breaks = c(1, 10, 10^2, 10^3, 10^4, 10^5, 10^6, 10^7),
                     labels = trans_format("log10",math_format(10^.x))) +
  scale_y_continuous(trans = pseudo_log_trans(base = 10),
                     breaks = c(10^0, 10^1, 10^2, 10^3, 10^4, 10^5, 10^6, 10^7),
                     labels = trans_format("log10",math_format(10^.x))) +
  coord_cartesian(xlim = c(1, 10^8), ylim = c(1, 10^8)) +
  theme_minimal() +
  theme(plot.margin = margin(1, 1, 0.5, 0.5, "cm"),
        axis.text = element_text(size=14),
        axis.title = element_text(size=20),
        axis.line = element_line(size = 1, color = "black"))
